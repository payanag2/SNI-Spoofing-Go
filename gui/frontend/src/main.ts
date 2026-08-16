import "@fontsource/vazirmatn/400.css";
import "@fontsource/vazirmatn/600.css";
import "@fontsource/vazirmatn/700.css";

import "./i18n";
import "./style.css";
import { mount } from "svelte";
import App from "./App.svelte";
import { SaveConfig } from "../wailsjs/go/main/App.js";

const app = mount(App, {
  target: document.getElementById("app")!,
});

function addSaveButton() {
  const actions = document.querySelector("main > section.panel:first-child .actions");
  if (!actions || actions.querySelector(".save-config-btn")) return;

  const button = document.createElement("button");
  button.type = "button";
  button.className = "btn save-config-btn";
  button.textContent = "Save";
  button.title = "Save configuration next to the application";
  button.addEventListener("click", async () => {
    const root = document.querySelector("main > section.panel:first-child");
    if (!root) return;
    const fields = Array.from(root.querySelectorAll<HTMLInputElement | HTMLSelectElement>("input, select"));
    if (fields.length < 11) return;

    const value = (index: number) => fields[index]?.value ?? "";
    const numberValue = (index: number) => Number(value(index));
    const cfg = {
      listen: value(0),
      connect: value(1),
      fakeSni: value(2),
      utls: value(3),
      injector: value(4),
      fakeRepeat: numberValue(5),
      fakeDelayMs: numberValue(6),
      ackTimeoutMs: numberValue(7),
      enableFragment: (fields[8] as HTMLInputElement).checked,
      fragmentDelayMs: numberValue(9),
      sniChunk: numberValue(10),
    };

    button.disabled = true;
    try {
      await SaveConfig(cfg);
      button.textContent = "Saved";
      window.setTimeout(() => {
        button.textContent = "Save";
        button.disabled = false;
      }, 1200);
    } catch (err) {
      console.error("Save configuration failed", err);
      button.textContent = "Save failed";
      window.setTimeout(() => {
        button.textContent = "Save";
        button.disabled = false;
      }, 1800);
    }
  });

  actions.appendChild(button);
}

const observer = new MutationObserver(addSaveButton);
observer.observe(document.body, { childList: true, subtree: true });
addSaveButton();

export default app;
