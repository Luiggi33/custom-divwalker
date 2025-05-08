<script lang="ts">
    import './app.css';
    import {Input, Fileupload, Label, Helper, Button, Heading, Footer} from "flowbite-svelte";
    import {LinkOutline} from "flowbite-svelte-icons";

    let walkerName = $state<string>("DivWalker");
    let walkerJs = $state<string>("");
    let selectedFiles = $state<FileList | null>(null);
    let fileNames = $derived(
        selectedFiles
            ? Array.from(selectedFiles)
                .map((file) => file.name)
                .join(", ")
            : "No files selected"
    );
    const convertToBase64 = async (): Promise<string[]> => {
        if (selectedFiles) {
            return Promise.all(
                Array.from(selectedFiles).map(file => fileToBase64(file))
            );
        }
        return [];
    };
    const fileToBase64 = (file: File): Promise<string> => {
        return new Promise((resolve, reject) => {
            const reader = new FileReader();
            reader.onload = () => resolve(reader.result as string);
            reader.onerror = (error) => reject(error);
            reader.readAsDataURL(file);
        });
    };

    const divWalkerTemplate = (images: string) => `
    javascript:(function(){
        let currentElement=null;
        let selectionEnabled=true;
        let images=[${images}];
        if(!document.getElementById("##MrDivWalkerCss")){
            let elem=document.createElement("div");
            elem.id="##MrDivWalkerCss";
            elem.innerHTML=\`<style>.man {position: fixed;z-index: 1000;} .delete-highlight {background-color: skyblue !important;}</style>\`;
            document.body.appendChild(elem);
        }
        function onMouseDown(e){
            addWalkerIfSelectionEnabled();
        }
        function addWalkerIfSelectionEnabled(){
            if(selectionEnabled && currentElement != null){
                addWalker(currentElement);
                if(currentElement){
                    currentElement.classList.remove("delete-highlight");
                }
                currentElement=null;
                selectionEnabled=false;
            }
        }
        document.body.addEventListener('keypress', function(e){
            if(e.key === 'q' || e.key === '1'){
                addWalkerIfSelectionEnabled();
            }
        });
        function onMouseMove(e){
            if(!selectionEnabled) return;
            let x=e.clientX;
            let y=e.clientY;
            let elem=document.elementFromPoint(x, y);
            if(elem && currentElement !== elem){
                if(currentElement){
                    currentElement.classList.remove("delete-highlight");
                }
                currentElement=elem;
                currentElement.classList.add("delete-highlight");
            }
        }
        function addWalker(element){
            let boundingRect=element.getBoundingClientRect();
            let currentIndex=0;
            let currentX=boundingRect.left;
            let velocity=3;
            let direction=1;
            let mrDivWalker=document.createElement("img");
            mrDivWalker.classList.add("man");
            mrDivWalker.style.left=\`\${boundingRect.x}px\`;
            mrDivWalker.style.top=\`\${boundingRect.y - 64}px\`;
            document.body.appendChild(mrDivWalker);
            setInterval(() => {
                boundingRect=element.getBoundingClientRect();
                mrDivWalker.src=images[++currentIndex % images.length];
                currentX+=(velocity * direction);
                if(currentX+mrDivWalker.width>=boundingRect.right){
                    direction=-1;
                    currentX=boundingRect.right - mrDivWalker.width;
                    mrDivWalker.style.transform="scaleX(-1)";
                }
                if(currentX <= boundingRect.left){
                    direction=1;
                    currentX=boundingRect.left;
                    mrDivWalker.style.transform="scaleX(1)";
                }
                mrDivWalker.style.top=\`\${boundingRect.y - 64}px\`;
                mrDivWalker.style.left=\`\${currentX}px\`;
                mrDivWalker.style.display="block";
            },30);
        }
        document.addEventListener('mousemove', onMouseMove);
        document.addEventListener('mousedown', onMouseDown);
    })();`;

    async function generateWalker(event: MouseEvent) {
        const images: string[] = await convertToBase64();
        let imagesString: string = ""
        for (let i = 0; i < images.length; i++) {
            imagesString += "\"";
            imagesString += images[i];
            imagesString += "\"";
            if (i === images.length - 1)
                imagesString += ",";
        }
        walkerJs = divWalkerTemplate(imagesString);
    }
</script>

<main class="mx-auto max-w-2xl mt-8">
    <Heading tag="h1" class="mb-4 text-4xl font-extrabold">Custom DivWalker</Heading>
    <div class="mt-4">
        <Label for="walker_name" class="mb-2">1. Name Your Walker</Label>
        <Input type="text" id="walker_name" bind:value={walkerName} required/>
    </div>
    <div class="mt-4">
        <Label for="with_helper" class="mb-2">2. Upload images</Label>
        <Fileupload clearable bind:files={selectedFiles} multiple/>
        <Helper class="mt-1">Selected files: {fileNames}</Helper>
    </div>
    <div class="mt-4">
        <Label for="div_walker" class="mb-2">3. Generate Your Walker</Label>
        {#if walkerJs !== ""}
            <Button id="div_walker" color="dark" href={walkerJs}>
                <LinkOutline class="me-2 h-5 w-5"/>{walkerName}
            </Button>
        {:else}
            <Button id="div_walker" color="dark" onclick={generateWalker}>Click Me</Button>
        {/if}

    </div>
</main>

<Footer class="mt-8">
    <div class="w-full text-center text-gray-500">
        <div>
            <a href="https://github.com/philippschuetz/custom-divwalker" class="hover:underline mr-4">Project
                Repository</a>
            <a href="https://philippschuetz.com/privacy-policy.html" class="hover:underline">Privacy Policy</a>
        </div>
    </div>
</Footer>