# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vcs-snapshot

DESCRIPTION="Minimalistic personal calendar program"
HOMEPAGE="http://www.lightandmatter.com/when/when.html https://bitbucket.org/ben-crowell/when"
SRC_URI="https://bitbucket.org/ben-crowell/${PN}/get/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="amd64 ppc x86"

DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}"

DOCS=( README )

src_prepare() {
	default

	# Fix path for tests
	sed -i 's,^	when,	./when,' Makefile || die 'sed failed'
}

src_compile() {
	emake when.1
}

src_test() {
	# The when command requires these files, or attempts to run setup function.
	mkdir "${HOME}"/.when || die 'mkdir failed'
	touch "${HOME}"/.when/{calendar,preferences} || die 'touch failed'
	emake test
}

src_install() {
	dobin "${PN}"
	doman "${PN}.1"
	einstalldocs
}
