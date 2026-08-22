---
title: switch to linux
date: 2026-08-22
reading: 10 min read
tags: linux, OS, open-source
---

**I switched to Linux. You probably should too.**

<!--more-->

I fucking hate Windows.

There, I said it. macOS and Linux are far better. Windows just wins for gaming.

For years, Windows was just something I tolerated because it came installed on my computer. I used it because everyone else used it. I used it because certain games expected it. I used it because somewhere along the way, "PC" became almost synonymous with "Windows." But the more I learned about computers, the more ridiculous that relationship started to feel.

Why does the operating system on my own computer feel like something I am borrowing from Microsoft? Why am I being pushed toward accounts, services, browsers, recommendations, and features I never asked for? Why does an operating system feel so heavy and rough?

I love COMPUTERS, but I just get annoyed when either software or hardware is trash, yk what I mean.

That is what eventually pushed me toward Linux, not because Linux is perfect. Because I have dealt with Wayland issues, Bluetooth problems, and broken configuration files. But there is an important difference. When Linux breaks, I can usually investigate *why* and fix it, and it brings me a certain sense of joy. Basically, when I don't like the way something works, there is a good chance I can replace it. That feeling of control is what made me stay.

## Linux isn't an operating system

Well, technically, it is complicated. Linux itself is a kernel. It is the core software that sits between your hardware and the rest of the operating system. What most people actually install is a Linux distribution, or distro, which packages the Linux kernel with system software, libraries, utilities, a package manager, and usually a graphical environment.

This is why Ubuntu, Fedora, Debian, Arch, Linux Mint, and openSUSE can all be Linux while feeling completely different. I didn't understand this properly when I started. Then I fell into the rabbit hole.

You have distro families. Debian has Ubuntu and Linux Mint. Red Hat has Fedora. Arch has Arch itself and distributions such as Manjaro and EndeavourOS. You have different package managers such as `apt`, `dnf`, and `pacman`, respectively. You have desktop environments like GNOME and KDE Plasma. Then you can throw all of that away and use something like i3, Sway, Hyprland, niri, or another window manager. My own notes ended up looking like a map of this entire ecosystem. And that is one of the first things Linux teaches you.

Your operating system is not one giant rock. It is a collection of components. You can understand and configure them. Basically, you can actually build your own computing environment.

## My laptop should not have been this much fun

I don't have some ridiculous workstation with 64 GB of RAM and a $2,000 GPU. My laptop is really old. And Linux made that machine interesting again. It is all due to Linux that I am able to code now. The lightweight experience has saved me. This is why I respect Linus Torvalds so much (he's the creator of Linux).

Linux gives you choices about how much software runs on your machine and what graphical environment you use. You can run a full-featured desktop like GNOME or KDE Plasma, or use something much lighter. You can go completely keyboard-driven with a tiling window manager. That matters when your hardware isn't exactly a MacBook Pro or Dell XPS 14.

My point is Windows hardware requirements can push people toward unnecessary upgrades, while Linux can extend the useful life of existing hardware.

I don't need Microslop to tell me that my perfectly functional computer is obsolete.

## Then I discovered ricing

This is where things got stupid and fun. I started customizing everything: terminal, shell, WM, status bar, launcher, notifications, fonts, colors, keybindings. Eventually I realized I was no longer just using Linux. I was actually building a desktop. That's what people mean by ricing. It is basically customization taken to an unreasonable level.

You can have GNOME, and you can use Hyprland too. You can write your own scripts. You can completely change how windows behave and how you navigate your machine.

## The terminal changed how I think about computers

I used to think of the terminal as some old-school technology. Now I use it constantly. And no, you don't need to become a terminal wizard to use Linux. But learning a few basic commands changes everything.

You start understanding files, permissions, processes, services, environment variables, package management, SSH, logs, and system configuration. You stop clicking around looking for some obscure setting and start asking what is actually happening underneath.

Installing software can be as simple as using your distro's package manager.

On Debian-based systems, you will probably use `apt`.

On Fedora, `dnf`.

On Arch, `pacman`.

I specifically emphasize using the package manager instead of randomly installing packages in different ways, and following official documentation when something goes wrong.

That last part is important.

**Read the fucking documentation.**

Seriously.

Linux rewards curiosity, but it punishes blind confidence. Don't paste some random `sudo rm -rf` command from a Reddit comment because somebody named "xXArchDestroyerXx" said it fixes your problem. Understand what you are running.

## Linux is ridiculously good for programming

This is probably the biggest practical reason I use it.

I'm a programmer.

I live around Git, Python, C, compilers, terminals, SSH, package managers, text editors, build systems, and command-line tools. Linux feels like home for that kind of work.

A huge part of modern computing infrastructure runs on Linux. Servers, cloud infrastructure, containers, embedded systems, and development environments are deeply connected to the Linux ecosystem. You don't have to use Linux to become a programmer. That's BS. You can be an excellent developer on Windows or macOS too. But Linux gives you an environment where a lot of the machinery you eventually need to understand is sitting right in front of you. You can open the terminal and interact with the system directly. I particularly emphasize the ease of accessing programming languages and open-source libraries.

For me, Linux didn't just become an operating system. It became part of my programming environment.

## And then there is the open-source thing

This is the part that goes deeper than "Linux looks cool." A lot of software today is something you consume. You download and use it after agreeing to some terms. You wait for the company to decide what happens next. Open source gives you another model. You can inspect the code, report bugs, contribute, and learn from software written by people who are much better than you. You don't need to be Linus Torvalds to participate. You can start with a simple file. It is free and open-source software, which is a matter of computing freedom and user control.

## But Linux will piss you off

I'm not going to bullshit you about this. Linux has a learning curve.

Some cons are: hardware compatibility can vary. Some proprietary software doesn't work natively. Some applications simply aren't available. You can absolutely break your system if you start changing things without understanding them. Gaming is also the obvious elephant in the room.

Linux gaming has become dramatically better, especially with Steam and Proton, but Windows still has broader compatibility for PC gaming, particularly with certain multiplayer games and anti-cheat systems. So if your entire computer exists to play one Windows-only game, don't listen to me.

But you can dual-boot ;)

## So how should you switch?

Don't immediately nuke Windows. Start by trying Linux. Download a distro. Put it on a USB drive. Boot into the live environment. Play around.

If you're nervous, dual-boot.

I have followed roughly this process myself: choose a distro, check the laptop and UEFI configuration, check the Secure Boot state, disable Fast Startup, back up your data just in case, turn off BitLocker encryption, partition the disk, prepare the ISO on a USB drive, install Linux alongside Windows if desired, reboot, and update the system.

## Don't obsess over the perfect distro

This is another trap, which is fun! You can spend weeks watching videos about Arch vs Fedora vs Debian vs Ubuntu vs NixOS vs whatever the Linux internet is arguing about this week.

Pick something sane and start using it. Linux Mint is a good place to start if you want something familiar. Fedora is excellent if you want a modern desktop and a clean experience. It's one of my favorite distros. Ubuntu has an enormous ecosystem and community. Debian is famous for stability. Arch gives you more control and expects you to learn more. It's one of the best ones. NixOS and CachyOS are quite popular too. And eventually you might decide that none of them are exactly what you want. That's fine. You can just switch. Currently, Omarchy is one of my favorite distros. It's basically Arch + Hyprland with some customization. Basically, my daily drivers can be Fedora and Omarchy. Linux taught me more than anything else.

## So, should you switch?

If you want a computer that works exactly like Windows, with the same applications, the same workflows, and the same compatibility, Linux may annoy the hell out of you. If you want the easiest possible gaming PC, Windows still has a very strong argument.

But if you are a programmer, student, tinkerer, privacy-conscious user, someone running older hardware, or simply someone who looks at their computer and thinks, *"Why can't I change this?"*

Try Linux.

Don't install Arch because some YouTuber told you it makes you a real programmer. Don't spend six hours choosing between GNOME and KDE. Especially don't start ricing before you understand what you're changing.

Just install something reasonable and start using it.


