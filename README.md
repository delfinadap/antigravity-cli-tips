# Antigravity CLI tips

## Tip 0: Set up a terminal alias for quick access

To help you launch Antigravity CLI quickly, you can alias `agy` to just `a`.

To set this up, add this line to your shell config file (such as `~/.zshrc` or `~/.bashrc`):

```bash
alias a='agy'
```

## Tip 1: Set up AGENTS.md for project instructions

`AGENTS.md` is a file you place in your project root to give Antigravity CLI persistent instructions. Anything you write in it gets included in every prompt within that directory. It's great for things like coding conventions, project-specific rules, or how you want the agent to behave in general.

If you also use Claude Code, you can symlink `CLAUDE.md` to point to the same file so both tools share the same instructions:

```bash
ln -s AGENTS.md CLAUDE.md
```

## Tip 2: Talk to Antigravity CLI with your voice

I found that you can communicate much faster with your voice than typing with your hands. Using a voice transcription system on your local machine is really helpful for this.

On my Mac, I've tried a few different options:
- [superwhisper](https://superwhisper.com/)
- [MacWhisper](https://goodsnooze.gumroad.com/l/macwhisper)
- [Super Voice Assistant](https://github.com/ykdojo/super-voice-assistant) (open source, supports Parakeet v2/v3)

You can get more accuracy by using a hosted service, but I found that a local model is strong enough for this purpose. Even when there are mistakes or typos in the transcription, the AI is smart enough to understand what you're trying to say. Sometimes you need to say certain things extra clearly, but overall local models work well enough.

I think the best way to think about this is like you're trying to communicate with your friend. Of course, you can communicate through texts. That might be easier for some people, or emails, right? That's totally fine. That's what most people seem to do with these CLI tools. But if you want to communicate faster, why wouldn't you get on a quick phone call? You can just send voice messages. You don't need to literally have a phone call with Antigravity CLI. Just send a bunch of voice messages. It's faster, at least for me, as someone who's practiced the art of speaking a lot over the past number of years. But I think for a majority of people, it's going to be faster too.

A common objection is "what if you're in a room with other people?" I just whisper using earphones - I personally like Apple EarPods (not AirPods). They're affordable, high quality enough, and you just whisper into them quietly. I've done it in front of other people and it works well. In offices, people talk anyway - instead of talking to coworkers, you're talking quietly to your voice transcription system. I don't think there's any problem with that. This method works so well that it even works on a plane. It's loud enough that other people won't hear you, but if you speak close enough to the mic, your local model can still understand what you're saying.
