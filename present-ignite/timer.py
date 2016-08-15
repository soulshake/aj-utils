#!/usr/bin/env python
import sys
import time
import click
from slides import slides

args = sys.argv[1:]
if len(args) > 0:
    start = int(args[0])
else:
    start = 1

# each slide displays for 15 seconds
slide = ["*"] * 16
slide[0:9] = [click.style(second, fg='green') for second in slide[0:9]]
slide[9:13] = [click.style(second, fg='yellow') for second in slide[10:13]]
slide[13:15] = [click.style(second, fg='red') for second in slide[13:15]]


def present(start=1):
    for slide_num in range(start, 20):
        print(slides[slide_num])
        label = "[{}] ".format(str(slide_num)).rjust(5)
        click.secho(label, nl=False)
        for second in slide:
            click.secho("{}".format(second), nl=False)
            time.sleep(1)
        click.secho("")

present(start)


"""
You think you hate meetings? Let me tell you, some of us*
extra extra hate meetings because they're
basically a microaggression-filled hell where we get interrupted all the time and no one hears our ideas until Dave says them.
* If you don't know who I mean, keep an interruption tally at your next meeting and see who has the highest words-to-interruptions ratio. 


-Protip-
This technique is also great for:
multilingual groups
video conferences
crowd feedback

--
So, first of all, something you need to know about me is that I see flaws and bad design everywhere and a lot of things piss me off. You, as an enlightened audience of engineery people, I'm guessing you can identify.

<Partcipant observation>
We pitch an idea, perhaps too uncertainly - only to have a dude repeat it with authority.
False belief that women speak more than men during meetings
"Talk blocking" i.e. interruptions

<in which case you must hedge until your eyes bleed and the egos of your colleagues are comfortably padded from the pointy barbs of your feminine abrasiveness.>

You know: Literally repeat WHAT PEOPLE JUST SAID. Compliment others before explaining how wrong you think they are. Hedge a lot, especially if you're a woman.


-Protip-
This technique is also great for:
- multilingual groups
- video conferences
- crowd feedback

"""
