# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
PLOCALES="zh_CN"
PYTHON_COMPAT=( python2_7 )

inherit l10n python-single-r1 scons-utils toolchain-funcs vcs-snapshot

MY_P="${P#*-}"

DESCRIPTION="Chinese SunPinyin engine for IBus"
HOMEPAGE="https://github.com/sunpinyin/sunpinyin"
SRC_URI="https://github.com/${PN#*-}/${PN#*-}/archive/v${PV/_rc/-rc}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="LGPL-2.1 CDDL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+nls"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	$(python_gen_cond_dep '
		app-i18n/ibus[python(+),${PYTHON_MULTI_USEDEP}]
	')
	~app-i18n/sunpinyin-${PV}:=
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"
S="${WORKDIR}/${MY_P}"

PATCHES=( "${FILESDIR}"/${PN}-python3.patch )

src_prepare() {
	sed -i "/^locales/s/'.*'/$(l10n_get_locales | sed "s/\([^[:space:]]\+\)/\'\1\',/g")/" wrapper/ibus/SConstruct
	sed -i "s/python/${EPYTHON}/" wrapper/ibus/setup/${PN/-/-setup-}.in

	default
	tc-export CXX
}

src_compile() {
	escons -C wrapper/ibus \
		--prefix="${EPREFIX}"/usr \
		--libdir="${EPREFIX}"/usr/$(get_libdir) \
		--libexecdir="${EPREFIX}"/usr/libexec
}

src_install() {
	escons -C wrapper/ibus --install-sandbox="${D}" install
	dodoc wrapper/ibus/README
}
