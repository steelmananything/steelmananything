# How to Contribute

We welcome contributions.

By contributing, you must agree to release your contributions into the public domain with the [CC0 license](LICENSE.txt) by waiving all copyright and related or neighboring rights to your contributed content.

## Ways to Contribute

A [free GitHub.com account](https://github.com/signup) is required to contribute using the methods below:

1. You may [open an issue](https://github.com/steelmananything/steelmananything/issues/new?assignees=&labels=&template=Report.yml) to report an error, propose an edit, or start a discussion.
2. You may propose an edit to the site using a method below. Content is authored in [GitHub Flavored Markdown](https://github.github.com/gfm/).
    1. Navigate to a page [in the code](https://github.com/steelmananything/steelmananything/tree/main) -- for example, the ['What is Steelmanning?'](https://github.com/steelmananything/steelmananything/blob/main/_topics/steelmanning.md) page -- click the pencil edit button, make your change, and click Commit changes.
    2. Create a [pull request](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/about-pull-requests).

We reserve the right to deny or accept (with or without changes) contributions for any reason.

## Standards

### Citations

There should be a `<!-- References -->` section at the bottom of the Markdown file where references are placed (in alphabetic order). See an example on the [methodology page](https://github.com/steelmananything/steelmananything/blob/179eb2b/_topics/methodology.md?plain=1#L71). We use the [APA style](https://apastyle.apa.org/style-grammar-guidelines/references/examples) with Markdown characteristics which is the [Author–Date Citation](https://apastyle.apa.org/style-grammar-guidelines/citations/basic-principles/author-date) in square brackets, followed by a colon and space, then a link, then a space, then an apostrophe, then the APA citation, then a space, then the link again, and finally an apostrophe. If the link is a `http://doi.org/` link, but there is a public download available, then the first link should be the public download link, and the final link should be the DOI link.

```
[Author–Date]: Link 'APA Citation. Link'
```

For example:

```
<!-- References -->

[Sanger et al., 1977]: https://www.pnas.org/doi/pdf/10.1073/pnas.74.12.5463 'Sanger, F., Nicklen, S., & Coulson, A. R. (1977). DNA sequencing with chain-terminating inhibitors. Proceedings of the national academy of sciences, 74(12), 5463-5467. https://doi.org/10.1073/pnas.74.12.5463'
```

The Author–Date will be converted to an anchor link so it [should not include](https://stackoverflow.com/a/2849800) any characters other than a-z, A-Z, 0-9, &, !, $, ', (, ), *, +, ,, ;, =, -, ., _, ~, :, @, /, and ?. Most commonly, this means replacing characters with an accent with a close analog (e.g. `ü` with `u`). Such characters should be left in the APA Citation.

If a quote or comment is included, place it after the first apostrophe and follow it with `&#013;&#013;` (which may be used additionally at any point in the quote or comment as line breaks). If the first link is to a PDF, include the page number, if applicable, with `#page=4`. For example:

```
[Sanger et al., 1977]: https://www.pnas.org/doi/pdf/10.1073/pnas.74.12.5463#page=4 '"The method described here has a number of advantages over the plus and minus methods." (Page 4).&#013;&#013;Sanger, F., Nicklen, S., & Coulson, A. R. (1977). DNA sequencing with chain-terminating inhibitors. Proceedings of the national academy of sciences, 74(12), 5463-5467. https://doi.org/10.1073/pnas.74.12.5463'
```

#### Citation tips

One common way to get the APA citation is to search for the resource on [Google Scholar](https://scholar.google.com/), click the "Cite" link and copy the APA section.

#### Referencing citations

Reference citations within the text using the normal [Author–Date Citation](https://apastyle.apa.org/style-grammar-guidelines/citations/basic-principles/author-date) format. The reference should be a Markdown link with the link being `#` followed by the Author–Date Citation with spaces replaced with underscores. The most common case is to note the reference parenthetically; for example:

```
One of the articles on DNA Sanger sequencing ([Sanger et al., 1977](#Sanger_et_al.,_1977)) describes a faster and more accurate method than the original plus or minus method.
```

Originally, we used the reference-style links in Markdown (i.e. `[Sanger et al., 1977][]`). This had the nice feature that anything within the apostrophes of the citation was placed in the `title` of the link and quickly seen as a hover tooltip with the mouse; however, we received feedback that, first, this doesn't work on mobile, and second, this means that citations aren't explicitly written which means they're not seen when printing. Therefore, we chose to have normal links that take the reader to the references section and from there they can go to the underlying reference link.
