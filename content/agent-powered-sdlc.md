# How to agentify your entire software development lifecycle

*This is an adapted version of [this video](https://youtu.be/K3YYr6yauAw) on the Google Cloud Tech YouTube channel. The slides are available [here](https://ykdojo.github.io/antigravity-cli-tips/content/sdlc-slides.html).*

I wanted to start with a common complaint about agentic coding: people write a lot of features with it, but then they write a lot of bugs, too. More code tends to naturally lead to more tech debt. In my opinion, part of the reason we have these problems is that we tend to over-rely on these agents to generate code, but not enough for maintaining it, reviewing it, or testing it.

That's exactly the motivation behind this post. I'll walk through a simplified version of the software development lifecycle (SDLC):

1. Identify and understand the issue
2. Design a solution
3. Implement it
4. Review and test it

Obviously this doesn't cover all of SDLC, but it should be sufficient for this discussion. Let's go through these steps one by one.

## Step 1: Identifying and understanding the issue

I have two example issues to cover here.

The first one is simple enough that it doesn't really need help to understand, but it'll be important later. For context: if you go to gitfut.com/yourusername, you get a website that gives you a score for your GitHub contributions, with stats like commits and stars earned, sort of a football (soccer) card kind of thing. The nice thing about it is that it's open source. I was looking through it and found an issue, which I [copied to my own fork](https://github.com/ykdojo/gitfut/issues/1) so I could work on it there. The problem this person had was that his last name is "De Ruwe" in two words, but his player card was only showing "Ruwe". This issue is short enough that I can just read it myself, but we'll come back to it later.

![My GitFut card page](sdlc-gitfut-card.png)

The second example is [an issue on Daft](https://github.com/Eventual-Inc/Daft/issues/6296), an open source data processing library I've been part of for a while. If you look through this issue, you notice it's pretty complex. There's an attached discussion that's also complex on its own.

![The Daft issue about supporting the LeRobot format](sdlc-daft-issue.png) I could totally read it sentence by sentence myself, but I found that a nice way to handle this part of the process is to just give it to a tool like Antigravity and say:

> Can you summarize this issue as well as the attached discussion and tell me what's going on? What's the problem exactly? What's the status?

That way you can speed up the process of identifying and understanding the issue. It's especially useful when there are a lot of discussions going on and a lot of attached PRs and issues.

Once the agent comes back with a summary, I go back and forth with it to dig into specific parts. For example, if the summary is long, I might say:

> You gave me a lot of information. It's a lot for me to read, so can you summarize it further? And also give me a summary of this PR that you mentioned, [7184](https://github.com/Eventual-Inc/Daft/pull/7184).

This is a process I use a lot, going back and forth with the agent to dig into certain issues or materials. I might also ask it to open certain pages so I can dig into those things myself, too.

## Step 2: Designing the solution

Going back to the GitFut example (by the way, I'm not associated with this project in any way, I'm just a fan): I was looking at my own card, and I noticed I have this score and these stats, but I thought, how good is it really? What does this number mean? I thought it would be convenient to see a distribution of GitHub users and where you rank in relation to them. So I decided to implement this feature and actually [sent a PR](https://github.com/Younesfdj/gitfut/pull/37). The idea is you add a new distribution tab, so you can see whether you're in the top X% of GitHub users or top X% of active devs.

![The distribution section on my GitFut card](sdlc-gitfut-distribution.png)

For this, I needed to design a couple of things. The visual look of it was relatively trivial compared to the system side of things: how do you actually gather this data in a privacy-friendly way? How do you store it? How do you show it?

For that, I had a long conversation with a coding agent. I asked questions like: what's a good way to fetch all the data? Can I fetch 20,000 accounts? It turns out I was able to do that. In the end, I fetched about 20,000 accounts and stored them in a privacy-friendly, anonymized way in the code itself, so it's efficient. I also looked at how many of those accounts were active in the past year. You can look at the PR itself to see how it was implemented. This goes a little bit into implementation too, but this is an example where an agentic process for this part of the SDLC was really helpful.

## Step 3: Implementing it

Now let's go back to the name issue from step 1 and implement a fix.

If you look at the original issue, the person who submitted it has a name with three parts, and his last name is the last two parts ("De Ruwe"). But the app thought his last name was just the last part. On the original project, it looks like they fixed it by automatically detecting that the last two names might be the last name. But that's not always the case, right? For example, I have a middle name. If I had my full name on my account, it would be first name, middle name, last name. If you assume the last two names are the last name, that would be wrong.

The way I would personally solve it is different: I would make it customizable. The issue itself actually already mentioned this approach. The person said this might not be easy since GitHub only has a setting for full name, but maybe the user could change the appearance of their name on the card, like they can pick a country. What they mean by that is there's already a way to pick your country on your card, and it's stored as a URL parameter. If I pick Canada, the URL says country=CA. If I go to a new page, it's stored. If I remove it, it's removed. So what they're saying is: let's make the name customizable like that, which I think is a reasonable approach.

At this point, I've identified the problem and designed a solution, so I can start implementing. The way I go about it is I take the URL of the repo I'm working on (in this case my fork, so I don't affect the original project) and prompt something like:

> I'm working on this repository. It is a fork, so make sure to stay on this fork. I'm not sure if it's cloned yet. If not, you can clone it. If it's already cloned, pull the latest version and switch to the main or master branch.

I keep all my Antigravity projects in a single projects folder, so Antigravity knows where to look for them. Then I describe the issue:

> I'm working on this issue. The way I want to work on it is I want it to be like the country selector. If you look at the country selector, you can hover over it on anyone's card, select a country, and that's stored in the URL parameter. Can we do the same thing for the name? For the name within the card, maybe there's an overlay element I can hover over and edit the name to whatever I want, so that it's also stored in the URL parameter.

That's the kind of prompt I would use for this task. While that runs, small tips from the demo: I didn't remember the command for running the project locally, so I just asked Antigravity:

> I've been working on this project, but I forgot how to run it. Was it npm run dev? Remind me, and actually run it for me so I can check it.

It looked at package.json, confirmed the command, and ran it for me.

The end result: on the card, there's now a way to edit the name, and if the person from the issue wants to use their full name, they can do it that way, stored in the URL parameter. This is, to me, the most comprehensive solution, instead of trying to be smart about which part is the last name exactly. Maybe I just want to use my first name only, or my nickname. This is the most flexible and comprehensive solution in my opinion.

## Step 4: Reviewing and testing

For this step, I have [the complete version of the PR](https://github.com/ykdojo/gitfut/pull/2) I was just working on. The title and description were all generated through Antigravity, and there are quite a few changed files.

![The PR with the card name picker changes](sdlc-gitfut-pr.png)

Let's say someone else on my team created this PR, or maybe I created it and forgot about it a little bit, and I want to review it before sending it out. There's a lot here, and there are a couple of ways to review it. Obviously you can review everything manually, but I found that an interactive way of reviewing is pretty effective. I'll say something like:

> I have this PR that I want to review. I see that there are a lot of files that changed. Can you summarize each one for me so I can review them one by one? Keep each summary to one or two sentences so that it's easy to review.

It fetches the information from GitHub (or wherever you host your code) directly and summarizes each file for me. Then I go through them one by one. If a summary is good enough and the change makes sense, I mark that file as viewed. If something surprises me, like a sharing utility file that changed and I don't quite understand why when I look at it manually, I can say:

> I don't quite understand this part. Can you explain this line by line?

There's this question about craft: how much of the code do you need to understand? How much do you want to understand? To me, this is the answer. You don't necessarily have to understand everything manually, but you have to know that there's always an option to dig in with however much depth you need, line by line if necessary. Tools like Antigravity are helpful for speeding up the process. It doesn't mean you lose control of your code. On the contrary, I think you gain more control by being able to dig into any part of the codebase more easily.

## Wrapping up

So that's the entire (again, simplified) SDLC: identify and understand the issue, design a solution, implement it, and review and test it, with agents helping at every step.

If you want more tips like this, check out the rest of [this repo](../README.md), and you can watch the full video version of this post [here](https://youtu.be/K3YYr6yauAw).
