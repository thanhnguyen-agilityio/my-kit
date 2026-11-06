# Claude: 15 tips for smart models

How to get more out of a strong model like Opus. Learned from Ben AI's video ([YouTube](https://youtu.be/Q0ArTNWXeAU)) and guide ([Notion](https://benai.notion.site/Claude-15-Tips-Guide-40f1124570fe819786bef59df6a390e8)). My own notes on how each tip fits this kit are marked **In my kit**.

## Asking

### 1. Be ambitious

Smart models can do much more than small edits. Hand over the whole job, not one step of it, and see how far it gets before you cut the scope down.

### 2. Write a brief, not a prompt

A brief has four parts:

| Part | What to write |
| --- | --- |
| **The job** | What you want done and what the output is. |
| **Why** | The goal behind it, who it is for. The model makes better calls when it knows why. |
| **Rules** | Constraints: what not to touch, style, tools, limits. |
| **Done** | How you and the model will know it is finished: tests pass, file exists, checklist ticked. |

### 3. Pre-plan the task

Before you write the brief, work out what you actually want. Let Claude question you first (an "interview me" or "grill me" skill), then turn the answers into the brief.

**In my kit:** the grill step in [`ai/ticket-to-pr/`](../ai/ticket-to-pr/) does this for tickets.

### 4. Make output visual

Ask for a page, diagram, table or deck instead of a wall of text. It is faster to review and easier to share. In Claude this means an Artifact.

### 5. Ask for variants

Ask for 3 versions (layouts, names, approaches) and pick or mix. One answer hides the options.

### 6. Rewind the chat

When an answer goes wrong, go back and edit the earlier message instead of arguing in new messages. The bad turns leave the context and stop steering the model.

### 7. Match the effort level to the task

Ask in order and stop at the first "yes":

| Question | Effort |
| --- | --- |
| Do you want quick back and forth, or is it simple? | **Low** |
| Would a hidden mistake be costly? | **High** |
| Is it long, hard and critical? | **Extra high / max** |
| Everything else | **Medium** |

## Building

### 8. Make skills from real work

Build skills from work you already did, not from scratch:

| Starting point | How to make the skill |
| --- | --- |
| You have an output you are happy with | Give it to Claude and reverse-engineer the skill from it. |
| You have done the task with Claude before | Do it together once more, then turn the process into a skill. |
| You do it by hand in another app | Record it with a skill-recording feature and turn the recording into a skill. |

**In my kit:** the `kit-harvest.md` file in [`templates/my-project/`](../templates/my-project/) collects candidates.

### 9. Keep your Claude setup clean

Old skills, rules and MCP servers pile up, cost context and confuse the model. Build a `/detox` skill that lists unused or overlapping items and suggests what to remove, and schedule it weekly.

### 10. Compact the chat at about 40%

Quality drops as the context fills. Compact (or hand off to a fresh chat with a summary) at around 40% of the window, not when it is full.

### 11. More subagents, cheaper models

Split work into subagents and give each the cheapest model that can do its part. The main chat stays small and the bill stays low.

**In my kit:** the model rules in the root [`CLAUDE.md`](../CLAUDE.md): Opus advises, Sonnet codes, Haiku does mechanical work.

## Working

### 12. Use Claude Code projects

Keep each body of work in a project with its own instructions and files, so you stop repeating context.

### 13. Keep track of your cache

Prompt cache expires after a while. A long pause means the next message re-reads everything at full price. Use a mod such as a cache clock to see how long is left, and hand off to a new chat instead of resuming a cold one.

### 14. Use side chats

Ask a quick unrelated question in a side chat so it does not pollute the main context.

### 15. Set up a second brain

Keep notes, templates and lessons in one place Claude can read.

**In my kit:** this repo is my second brain.
