# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1

DESCRIPTION="Command line shell and scripting interface for Drupal"
HOMEPAGE="https://github.com/drush-ops/drush"
SRC_URI="https://github.com/drush-ops/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="dev-lang/php[cli,ctype,json(+),simplexml]
	dev-php/PEAR-Console_Table"

PATCHES=(
	"${FILESDIR}/update-bash-completion-script-for-2.1.patch"
	"${FILESDIR}/array-syntax.patch"
	"${FILESDIR}/${P}-php8.0.patch"
	"${FILESDIR}/${P}-gzip-mime.patch"
)

src_prepare() {
	default

	# dodoc compresses all of the documentation, so we fix the filenames
	# in a few places.
	#
	# First, the README location in bootstrap.inc.
	sed -i -e \
		"s!/share/doc/drush!/share/doc/${PF}!" \
		-e "s!README\.md!\0.bz2!g" \
		includes/bootstrap.inc || die

	# Next, the list of documentation in docs.drush.inc. Note that
	# html files don't get compressed.
	sed -i \
		-e "s!\.bashrc'!.bashrc.bz2'!" \
		-e "s!\.inc'!.inc.bz2'!" \
		-e "s!\.ini'!.ini.bz2'!" \
		-e "s!\.md'!.md.bz2'!" \
		-e "s!\.php'!.php.bz2'!" \
		-e "s!\.script'!.script.bz2'!" \
		-e "s!\.txt'!.txt.bz2'!" \
		commands/core/docs.drush.inc || die
}

src_install() {
	# Always install the examples; they're referenced within the source
	# code and too difficult to exorcise.
	dodoc -r README.md docs examples

	insinto /usr/share/drush
	doins -r classes commands includes lib misc
	doins drush_logo-black.png drush.info drush.php

	exeinto /usr/share/drush
	doexe drush
	dosym ../share/drush/drush /usr/bin/drush

	keepdir /etc/drush
	newbashcomp drush.complete.sh drush
}
