---
title: basics of ml
date: 2026-05-32
reading: 8 min read
tags: ai, ml, learning
---

**it all started back in 2022 when chatgpt 3.5 dropped. ever since childhood, i had imagined a tool like that. it felt unreal at the time.**

<!--more-->

it all started back in 2022 when chatgpt 3.5 dropped. ever since childhood, i had imagined a tool like that. it felt unreal at the time. the responses, the conversations, the feeling that a machine could actually understand what you were saying. i was still in school back then. honestly, i still am lol. but in 2025, after getting completely overwhelmed by ai, vibe coding, and the nonstop hype online, i created a twitter account to figure out what was actually happening under the hood and stay updated with the latest news.

twitter is a really interesting place.

some people there are building insane things. some are just farming engagement. but somewhere between all the noise, i discovered something important: underneath modern ai is machine learning.

machine learning is the thing powering almost everything we call ai today.

later, i also got interested in reinforcement learning after watching different rl environments online. it genuinely looked like video games. agents learning through trial and error, improving after every attempt, slowly figuring things out on their own. i loved it instantly.

anyway, without wandering too much, this blog is my attempt to walk you through the fundamentals of machine learning in simple words. i'm nowhere near an expert yet, but i've learned a lot through different resources, especially andrew ng's machine learning course, and i want to share those ideas in the simplest way possible.

i still remember the first time i truly understood machine learning.

i was watching andrej karpathy explaining the working of llms. that was it. i got hooked immediately. before that, i thought machine learning was all about memorizing complicated equations and impossible math. but it really isn't. at its core, machine learning is about patterns. it's about letting computers discover those patterns on their own instead of hard-coding every rule manually.

so what actually is machine learning?

the most common definition, and honestly still the best one i've found, is this:

> machine learning is a field of study that gives computers the ability to learn without being explicitly programmed.

think about email spam filters.

years ago, engineers had to manually write rules like:

> "if the email contains the phrase 'nigerian prince,' mark it as spam."

but scammers adapted quickly. they changed words, formatting, and patterns. the rules kept breaking.

today, instead of writing rules manually, we show algorithms millions of examples of spam and non-spam emails. the algorithm studies the patterns and learns by itself.

that's machine learning.

another way i like to explain it is this:

> machine learning is the art of teaching computers to recognize patterns in data and make predictions without giving them step-by-step instructions.

everything else in ai basically builds on top of that idea.

traditional programming works like this:

> input + rules = output

you write the rules yourself.

machine learning flips the equation:

> input + output = rules

the machine figures out the rules on its own.

that's the breakthrough.

for decades, computers were only good at tasks where humans could clearly define instructions. things like calculating taxes, sorting numbers, or managing databases worked perfectly because the logic was straightforward. but some problems are too complicated for manual rules.

how do you explicitly program a computer to:

- recognize a cat in an image?
- understand human speech?
- recommend the perfect youtube video?
- predict stock market behavior?

you can't realistically write millions of tiny rules for every situation.

machine learning solves this problem by allowing systems to learn from examples instead. feed enough data into an algorithm, and it starts identifying hidden relationships on its own. that's why machine learning became the foundation of modern ai.

at its heart, machine learning is really just pattern recognition.

imagine showing a computer thousands of house listings with information like:

- square footage
- number of bedrooms
- location
- price

eventually, the model notices relationships.

bigger houses usually cost more.

better locations increase value.

more bedrooms often affect pricing.

using those patterns, the computer creates a mathematical model capable of predicting prices for houses it has never seen before.

that prediction ability is what makes machine learning powerful.

andrew ng's course introduces three major types of machine learning. they sound intimidating at first, but you already interact with all of them in your everyday life.

## 1. supervised learning

supervised learning is learning with an answer key.

we provide the algorithm with both the input and the correct output, almost like giving a student solved examples before a test.

for example, imagine predicting house prices.

inputs:

- size
- location
- number of bedrooms

output:

- price

the algorithm studies thousands of houses that have already been sold and learns the relationship between features and prices.

spam detection works the same way.

input:

- email text

output:

- spam or not spam

the model studies labeled examples until it starts recognizing patterns by itself.

this is called supervised learning because humans provide the correct answers during training.

one major supervised learning task is called **regression**.

regression is used when the output is a number.

examples include:

- predicting house prices
- forecasting revenue
- estimating temperature
- predicting sales

a simple regression model tries to learn the relationship between inputs and outputs mathematically.

for example, larger houses usually cost more.

the algorithm attempts to draw the best possible line through the data so it can make accurate predictions for new examples.

another supervised learning task is **classification**.

sometimes we don't want numerical predictions. we want decisions.

questions like:

- is this email spam?
- is this transaction fraudulent?
- does this image contain a cat?
- is this tumor dangerous?

these are classification problems.

instead of predicting numbers, the model predicts categories.

classification systems power many ai applications we use daily.

## 2. unsupervised learning

now imagine giving a machine data without any labels or answers.

no categories and instructions. basically, no "correct" outputs.

that's unsupervised learning.

the algorithm has to find structure in the data completely on its own.

a good example is customer segmentation.

suppose a company has data about what people buy, how much they spend, and how often they visit a website. nobody labeled customers as "luxury shoppers" or "budget buyers." the algorithm groups similar people together automatically and discovers hidden patterns humans may never notice. google news grouping similar articles from different websites is another example.

unsupervised learning honestly feels magical sometimes because it uncovers structure inside chaos.

one common unsupervised learning technique is **clustering**.

clustering simply means grouping similar things together.

examples:

- similar customers
- similar songs
- similar movies
- similar user behavior

spotify recommendations and many recommendation systems rely heavily on these ideas.

## 3. reinforcement learning

reinforcement learning is completely different from the other two.

in rl, an agent interacts with an environment and learns through rewards and penalties.

imagine teaching a computer to play chess.

the ai makes moves. if it wins, it receives positive feedback.

if it loses, it receives negative feedback. over millions of games, it slowly learns winning strategies on its own. no human manually teaches every move.

another example is a robot learning how to walk in a simulation. it falls repeatedly at first, but every mistake helps it improve slightly until it eventually learns balance and movement.

reinforcement learning is a massive field by itself, and honestly, i'm not goated enough yet to explain the deeper parts properly in this blog.

### there are also a few terms you'll hear constantly while learning machine learning.

## features

features are simply the characteristics of your data.

if you're predicting house prices, features could include:

- square footage
- number of bedrooms
- zip code

think of features as spreadsheet columns.

## model

a model is the mathematical representation of the patterns the algorithm learned.

it's the thing that actually makes predictions after training.

## training

training is the process of feeding data into the algorithm so it can learn patterns.

you can think of it like repeatedly showing someone flashcards until they start recognizing answers automatically.

## generalization

generalization is one of the most important ideas in machine learning.

a good model shouldn't just memorize training examples. it should perform well on completely new, unseen data. memorizing answers is not learning. it's cheating. and cheating stops working the moment the questions change.

## thoughts

alright, i've just given you some basic groundwork here. it's not possible to write an entire book here, especially since i'm not an expert yet either. now, you should go study mathematics and machine learning, and check out the resources below.

now, machine learning is often presented as something mysterious or almost magical. but underneath all the hype, the core idea is surprisingly simple:

> experience improves performance.

humans learn from experience.

machines can too.

the difference is that machines can learn from millions of examples at a scale humans never could. that's why machine learning is transforming almost every industry today. honestly, i think it's one of the most important inventions humanity has ever created.

it's also one of the most interesting subjects i've studied recently. the deeper you go into it, the more everything starts making sense. there's a lot of hype online, though, and honestly, most of it is noise.

don't get trapped by that.

study deeply.

understand the fundamentals.

build things.

stay curious.

and remember this:

> **you're literally what ai is trying to become.**

# resources

1. [cs231n by andrej karpathy](https://www.youtube.com/playlist?list=PLlQXC4BDK2Qjtv-9pypk0xUu8zEE1C0tD)

2. [machine learning specialization by andrew ng](https://www.deeplearning.ai/specializations/machine-learning)
