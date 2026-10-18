# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

NEED_EMACS="27.1"

inherit toolchain-funcs elisp

DESCRIPTION="Full-featured unofficial GNU Emacs client for Telegram"
HOMEPAGE="https://zevlg.github.io/telega.el/
	https://github.com/zevlg/telega.el/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/zevlg/${PN}.el"
else
	[[ "${PV}" == *p20260806 ]] && COMMIT="c7273cce799d60b6c8bb470cfa26ed267324ff02"
	SRC_URI="https://github.com/zevlg/${PN}.el/archive/${COMMIT}.tar.gz
		-> ${P}.gh.tar.gz"
	S="${WORKDIR}/${PN}.el-${COMMIT}"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-3+"
SLOT="0"
RESTRICT="test"

DEPEND="
	net-libs/tdlib:0/1.8.66
	virtual/zlib:=
"
RDEPEND="
	${DEPEND}
	>=app-editors/emacs-${NEED_EMACS}:*[jpeg,png,svg]
	>=app-emacs/all-the-icons-4.0.0
	>=app-emacs/dashboard-1.8.0
	>=app-emacs/transient-0.9.0
	>=app-emacs/visual-fill-column-1.9
	app-emacs/company-mode
"
BDEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

ELISP_REMOVE="
	Makefile
	contrib/telega-alert.el
	contrib/telega-channels-export.el
	contrib/telega-live-location.el
	contrib/telega-mnz.el
	test.el
"
PATCHES=( "${FILESDIR}/telega-0.8.660-gentoo.patch" )
DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	elisp_src_prepare
	sed -i "s|@SITEETC@|${EPREFIX}${SITEETC}/${PN}|" ./telega-core.el || die
	mv ./contrib/*.el ./ || die
}

src_compile() {
	elisp_src_compile
	elisp-make-autoload-file

	# This is probably better than patching telega-server's Makefile.
	cd server || die
	local -a cc_flags=(
		$(pkg-config --cflags tdjson) $(pkg-config --libs tdjson)
		$(pkg-config --cflags zlib) $(pkg-config --libs zlib)
		-DWITH_ZLIB
		-pthread
		-Wall -Wextra
		${CFLAGS} ${LDFLAGS}
		-o telega-server
		telega-server.c telega-dat.c telega-pngext.c
	)
	edo "$(tc-getCC)" "${cc_flags[@]}"
}

src_install() {
	elisp_src_install
	dobin ./server/telega-server
	insinto "${SITEETC}/${PN}"
	doins -r ./etc/.
}
