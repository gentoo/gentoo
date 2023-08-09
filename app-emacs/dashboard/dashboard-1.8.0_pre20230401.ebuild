# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=26.1

inherit elisp

DESCRIPTION="Extensible Emacs dashboard, with sections like bookmarks, agenda and more"
HOMEPAGE="https://github.com/emacs-dashboard/emacs-dashboard/"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/emacs-dashboard/emacs-${PN}.git"
else
	if [[ ${PV} == *pre20230401 ]] ; then
		COMMIT=0f970d298931f9de7b511086728af140bf44a642
		SRC_URI="https://github.com/emacs-dashboard/emacs-${PN}/archive/${COMMIT}.tar.gz
			-> ${P}.tar.gz"
		S="${WORKDIR}"/emacs-${PN}-${COMMIT}
	else
		SRC_URI="https://github.com/emacs-dashboard/emacs-${PN}/archive/${PV}.tar.gz
			-> ${P}.tar.gz"
		S="${WORKDIR}"/emacs-${PN}-${PV}
	fi
	KEYWORDS="amd64 x86"
fi

LICENSE="GPL-3+"
SLOT="0"

DOCS=( CHANGELOG.md README.org etc )
PATCHES=( "${FILESDIR}"/${PN}-1.8.0-dashboard-widgets.el-banners.patch )

ELISP_REMOVE=( .dir-locals.el )
SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	elisp_src_prepare

	sed "s|@SITEETC@|${EPREFIX}${SITEETC}/${PN}|" -i dashboard-widgets.el || die
}

src_test() {
	${EMACS} ${EMACSFLAGS} ${BYTECOMPFLAGS} \
		-L . -L test -l ${PN}.el -l test/activate.el || die "tests failed"
}

src_install() {
	elisp_src_install

	insinto "${SITEETC}"/${PN}
	doins -r banners
}
