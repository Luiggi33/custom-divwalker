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

    const divWalkerTemplate = (value: string) => `javascript:(function(){let currentElement = null;let selectionEnabled = true;let images = [${value}];if(!document.getElementById("##MrDivWalkerCss")){%20%20%20%20let%20elem%20=%20document.createElement("div");%20%20%20%20elem.id%20=%20"##MrDivWalkerCss";%20%20%20%20elem.innerHTML%20=%20\`<style>.man{position:%20fixed;z-index:1000;}%20.delete-highlight{background-color:%20skyblue!important;}</style>\`;%20%20%20%20document.querySelector("body").appendChild(elem);}function%20onMouseDown(e){%20%20%20%20addWalkerIfSelectionEnabled();}function%20addWalkerIfSelectionEnabled(){%20%20%20%20if(selectionEnabled%20&&%20currentElement%20!=%20null)%20%20%20%20{%20%20%20%20%20%20%20%20addWalker(currentElement);%20%20%20%20%20%20%20%20if(currentElement)%20{currentElement.classList.remove("delete-highlight");}%20%20%20%20%20%20%20%20currentElement%20=%20null;%20%20%20%20%20%20%20%20selectionEnabled%20=%20false;%20%20%20%20}}document.querySelector('body').addEventListener('keypress',%20function%20(e)%20{%20%20%20%20if%20(e.key%20===%20'q'%20||%20e.key%20===%20'1')%20{%20%20%20%20%20%20%20%20addWalkerIfSelectionEnabled();%20%20%20%20}});function%20onMouseMove(e){%20%20%20%20if(!selectionEnabled)%20return;%20%20%20%20let%20x%20=%20e.clientX;%20%20%20%20let%20y%20=%20e.clientY;%20%20%20%20let%20elem%20=%20document.elementFromPoint(x,y);%20%20%20%20if(elem%20&&%20currentElement%20!==%20elem)%20%20%20%20{%20%20%20%20%20%20%20%20if(currentElement){currentElement.classList.remove("delete-highlight");}%20%20%20%20%20%20%20%20currentElement%20=%20elem;%20%20%20%20%20%20%20%20currentElement.classList.add("delete-highlight");%20%20%20%20}}function%20addWalker(element){%20%20%20%20let%20boundingRect%20=%20element.getBoundingClientRect();%20%20%20%20let%20currentIndex%20=%200;%20%20%20%20let%20currentX%20=%20boundingRect.left;%20%20%20%20let%20velocity%20=%203;%20%20%20%20let%20direction%20=%201;%20%20%20%20let%20mrDivWalker%20=%20document.createElement("img");%20%20%20%20mrDivWalker.classList.add("man");%20%20%20%20mrDivWalker.style.left%20=%20\`\${boundingRect.x}px\`;%20%20%20%20mrDivWalker.style.top%20=%20\`\${boundingRect.y - 64}px\`;%20%20%20%20document.body.append(mrDivWalker);%20%20%20%20%20%20%20%20setInterval(()=>{%20%20%20%20%20%20%20%20boundingRect%20=%20element.getBoundingClientRect();%20%20%20%20%20%20%20%20mrDivWalker.setAttribute("src",%20images[++currentIndex%20%%20images.length]);%20%20%20%20%20%20%20%20currentX%20+=%20(velocity*direction);%20%20%20%20%20%20%20%20%20%20%20%20if(currentX%20+%2039%20>=%20boundingRect.right)%20%20%20%20%20%20%20%20{%20%20%20%20%20%20%20%20%20%20%20%20direction%20=%20-1;%20%20%20%20%20%20%20%20%20%20%20%20currentX%20=%20boundingRect.right-39;%20%20%20%20%20%20%20%20%20%20%20%20mrDivWalker.style.transform%20=%20"scaleX(-1)";%20%20%20%20%20%20%20%20}%20%20%20%20%20%20%20%20if(currentX%20<=%20boundingRect.left)%20%20%20%20%20%20%20%20{%20%20%20%20%20%20%20%20%20%20%20%20direction%20=%201;%20%20%20%20%20%20%20%20%20%20%20%20currentX%20=%20boundingRect.left;%20%20%20%20%20%20%20%20%20%20%20%20mrDivWalker.style.transform%20=%20"scaleX(1)";%20%20%20%20%20%20%20%20}%20%20%20%20%20%20%20%20%20%20%20%20mrDivWalker.style.top%20=%20\`\${boundingRect.y - 64}px\`;%20%20%20%20%20%20%20%20mrDivWalker.style.left%20=%20\`\${currentX}px\`;%20%20%20%20%20%20%20%20mrDivWalker.style.display%20=%20"block";%20%20%20%20},%2030);}document.addEventListener('mousemove',%20onMouseMove);document.addEventListener('mousedown',%20onMouseDown);})();`;

    async function generateWalker(event: MouseEvent) {
        const images: string[] = await convertToBase64();
        console.log(images);
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