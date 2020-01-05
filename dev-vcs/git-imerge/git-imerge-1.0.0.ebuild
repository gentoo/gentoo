# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_6} )

inherit bash-completion-r1 python-r1

DESCRIPTION="Incremental merge for git"
HOMEPAGE="https://github.com/mhagger/git-imerge"
SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	dev-vcs/git"
DEPEND="dev-python/docutils"

src_compile() {
	for doc in *.rst; do
		rst2html.py "${doc}" > "${T}/${doc/.rst/.html}" \
			|| die "failed to convert ${doc} to ${T}/${doc/.rst/.html}"
	done

	rst2s5.py \
		--theme=small-white \
		--current-slide \
		doc/presentations/GitMerge-2013/talk.rst \
		"${T}/talk.html" \
		|| die 'failed to convert talk.rst to ${T}/talk.html'
}

src_install() {
	python_foreach_impl python_doscript "${PN}"
	newbashcomp "${FILESDIR}/git-imerge.bashcomplete" git-imerge
	dodoc *.rst "${T}"/*.html

	# Don't forget the CSS for the presentation.
	dodoc -r "${T}/ui"
}
