# find potential tech debt

Script to analyze git repositories for potential tech debt by generating a report with lines of code and change rate. This does not point you to the actual tech debt, but is a starting point to see where improvements to your code base have the highest impact. Although not perfect we use lines of code as a proxy for complexity.

This script is heavily influenced by the book [Software Design X-Rays](https://github.com/SoftwareDesignXRays).

# prerequisites 

- [git effort](https://github.com/tj/git-extras/blob/master/man/git-effort.md)
- [cloc](https://github.com/AlDanial/cloc)
