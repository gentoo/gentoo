# Copyright 2009-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PYTHON_COMPAT=(python{3_7,3_8,3_9})

inherit python-any-r1 scons-utils toolchain-funcs

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/sunpinyin/sunpinyin"
elif [[ "${PV}" == *_pre* ]]; then
	SUNPINYIN_GIT_REVISION="f39c195db08661e894017507842991a1ef70bedf"
fi

DESCRIPTION="Statistical Language Model (SLM) based Chinese input method library"
HOMEPAGE="https://github.com/sunpinyin/sunpinyin"
if [[ "${PV}" == "9999" ]]; then
	SRC_URI=""
elif [[ "${PV}" == *_pre* ]]; then
	SRC_URI="https://github.com/sunpinyin/${PN}/archive/${SUNPINYIN_GIT_REVISION}.tar.gz -> ${P}.tar.gz"
else
	SRC_URI="https://github.com/sunpinyin/${PN}/archive/v${PV/_/-}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="|| ( CDDL LGPL-2.1 )"
SLOT="0/3"
KEYWORDS="amd64 ppc ppc64 ~riscv x86"
IUSE=""

BDEPEND="dev-lang/perl
	virtual/pkgconfig"
DEPEND="dev-db/sqlite:3
	virtual/libiconv"
RDEPEND="${DEPEND}"

if [[ "${PV}" == *_pre* ]]; then
	S="${WORKDIR}/${PN}-${SUNPINYIN_GIT_REVISION}"
elif [[ "${PV}" != "9999" ]]; then
	S="${WORKDIR}/${PN}-${PV/_/-}"
fi

src_prepare() {
	default
	sed -e "/^docdir =/s:/sunpinyin:/${PF}:" -i SConstruct || die

	# https://github.com/sunpinyin/sunpinyin/issues/109
	sed -e "/^Requires: sqlite3$/s/^Requires:/Requires.private:/" -i sunpinyin-2.0.pc.in || die
}

src_configure() {
	tc-export CXX
}

src_compile() {
	escons \
		--prefix="${EPREFIX}/usr" \
		--libdir="${EPREFIX}/usr/$(get_libdir)"
}

src_install() {
	escons --install-sandbox="${D}" install
}
