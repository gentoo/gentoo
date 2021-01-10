# Copyright 2009-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PYTHON_COMPAT=(python{3_6,3_7,3_8,3_9})

inherit python-single-r1 scons-utils toolchain-funcs

MY_PN="sunpinyin"
MY_P="${MY_PN}-${PV}"

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/sunpinyin/sunpinyin"
elif [[ "${PV}" == *_pre* ]]; then
	SUNPINYIN_GIT_REVISION="f39c195db08661e894017507842991a1ef70bedf"
fi

DESCRIPTION="Chinese SunPinyin engine for IBus"
HOMEPAGE="https://github.com/sunpinyin/sunpinyin"
if [[ "${PV}" == "9999" ]]; then
	SRC_URI=""
elif [[ "${PV}" == *_pre* ]]; then
	SRC_URI="https://github.com/sunpinyin/${MY_PN}/archive/${SUNPINYIN_GIT_REVISION}.tar.gz -> ${MY_P}.tar.gz"
else
	SRC_URI="https://github.com/sunpinyin/${MY_PN}/archive/v${PV/_/-}.tar.gz -> ${MY_P}.tar.gz"
fi

LICENSE="|| ( CDDL LGPL-2.1 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+gui"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

BDEPEND="sys-devel/gettext
	virtual/pkgconfig"
DEPEND="app-i18n/ibus
	~app-i18n/sunpinyin-${PV}
	dev-libs/glib:2
	virtual/libintl"
RDEPEND="${DEPEND}
	app-i18n/sunpinyin-data
	gui? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			app-i18n/ibus[introspection,python,${PYTHON_MULTI_USEDEP}]
			dev-python/pygobject[${PYTHON_MULTI_USEDEP}]
		')
		x11-libs/gtk+:3[introspection]
	)"

if [[ "${PV}" == *_pre* ]]; then
	S="${WORKDIR}/${MY_PN}-${SUNPINYIN_GIT_REVISION}"
elif [[ "${PV}" != "9999" ]]; then
	S="${WORKDIR}/${MY_PN}-${PV/_/-}"
fi

PATCHES=(
	"${FILESDIR}/${PN}-2.0.4_pre20200306162733-python-3.patch"
)

src_prepare() {
	default
	sed -e "/^exec python /s/python/${EPYTHON}/" -i wrapper/ibus/setup/ibus-setup-sunpinyin.in || die

	if ! use gui; then
		sed \
			-e "s:'setup/ibus-setup-sunpinyin'::" \
			-e "/env\.Alias('install-libexec'/s:, setup_target::" \
			-i wrapper/ibus/SConstruct || die
	fi
}

src_configure() {
	tc-export CXX
}

src_compile() {
	escons -C wrapper/ibus \
		--prefix="${EPREFIX}/usr" \
		--libdir="${EPREFIX}/usr/$(get_libdir)" \
		--libexecdir="${EPREFIX}/usr/libexec" \
		--datadir="${EPREFIX}/usr/share"
}

src_install() {
	escons -C wrapper/ibus --install-sandbox="${D}" install
}
