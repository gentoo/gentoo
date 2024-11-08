# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GUILE_COMPAT=( 2-2 3-0 )
LUA_COMPAT=( lua5-{1..4} )
PYTHON_COMPAT=( python3_{10..13} )

inherit cmake guile-single lua-single python-single-r1 xdg

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/weechat/weechat.git"
else
	inherit verify-sig
	SRC_URI="https://weechat.org/files/src/${P}.tar.xz
		verify-sig? ( https://weechat.org/files/src/${P}.tar.xz.asc )"
	VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/weechat.org.asc
	BDEPEND+="verify-sig? ( sec-keys/openpgp-keys-weechat )"
	KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86 ~x64-macos"
fi

DESCRIPTION="Portable and multi-interface IRC client"
HOMEPAGE="https://weechat.org/"

LICENSE="GPL-3+"
SLOT="0/${PV}"

NETWORKS="+irc"
PLUGINS="+alias +buflist +charset +exec +fifo +fset +logger +relay +scripts +spell +trigger +typing +xfer"
# dev-lang/v8 was dropped from Gentoo so we can't enable javascript support
# dev-lang/php eclass support is lacking, php plugins don't work. bug #705702
SCRIPT_LANGS="guile lua +perl +python ruby tcl"
LANGS=" cs de es fr hu it ja pl pt pt_BR ru sr tr"
IUSE="doc enchant man nls relay-api selinux test +zstd ${SCRIPT_LANGS} ${PLUGINS} ${INTERFACES} ${NETWORKS}"

REQUIRED_USE="
	enchant? ( spell )
	guile? ( ${GUILE_REQUIRED_USE} )
	lua? ( ${LUA_REQUIRED_USE} )
	python? ( ${PYTHON_REQUIRED_USE} )
	test? ( nls )
	relay-api? ( relay )
"

RDEPEND="
	dev-libs/libgcrypt:0=
	net-libs/gnutls:=
	sys-libs/ncurses:0=
	sys-libs/zlib:=
	net-misc/curl[ssl]
	charset? ( virtual/libiconv )
	guile? ( ${GUILE_DEPS} )
	lua? ( ${LUA_DEPS} )
	nls? ( virtual/libintl )
	perl? (
		dev-lang/perl:=
		virtual/libcrypt:=
	)
	python? ( ${PYTHON_DEPS} )
	relay-api? ( dev-libs/cJSON )
	ruby? (
		|| (
			dev-lang/ruby:3.3
			dev-lang/ruby:3.2
			dev-lang/ruby:3.1
		)
	)
	selinux? ( sec-policy/selinux-irc )
	spell? (
		enchant? ( app-text/enchant:* )
		!enchant? ( app-text/aspell )
	)
	tcl? ( >=dev-lang/tcl-8.4.15:0= )
	zstd? ( app-arch/zstd:= )
"

DEPEND="${RDEPEND}
	test? ( dev-util/cpputest )
"

BDEPEND+="
	virtual/pkgconfig
	doc? ( >=dev-ruby/asciidoctor-1.5.4 )
	man? ( >=dev-ruby/asciidoctor-1.5.4 )
	nls? ( >=sys-devel/gettext-0.15 )
"

DOCS="AUTHORS.md CHANGELOG.md CONTRIBUTING.md UPGRADING.md README.md"

RESTRICT="!test? ( test )"

pkg_setup() {
	use guile && guile-single_pkg_setup
	use lua && lua-single_pkg_setup
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	cmake_src_prepare

	use guile && guile_bump_sources

	# install only required translations
	local i
	for i in ${LANGS} ; do
		if ! has ${i} ${LINGUAS-${i}} ; then
			sed -i \
				-e "/${i}.po/d" \
				po/CMakeLists.txt || die
		fi
	done

	# install only required documentation ; en always
	local j
	for i in $(grep -e 'set(.*en.*)$' doc/CMakeLists.txt \
			| sed -e 's/.*set(\(\w\+\).*/\1/'); do
		for j in $(grep set.${i} doc/CMakeLists.txt \
				| sed -e "s/.*${i}\(.*\)).*/\1/" -e 's/ en//'); do
			if ! has ${j} ${LINGUAS-${j}} ; then
				sed -i \
					-e "s/\(set(${i}.*\) ${j}/\1/" \
					doc/CMakeLists.txt || die
			fi
		done
	done

	# install docs in correct directory
	sed -i "s#\${DATAROOTDIR}/doc/\${PROJECT_NAME}#\0-${PVR}/html#" doc/CMakeLists.txt || die

	if [[ ${CHOST} == *-darwin* ]]; then
		# fix linking error on Darwin
		sed -i "s/+ get_config_var('LINKFORSHARED')//" \
			cmake/FindPython.cmake || die
		# allow to find the plugins by default
		sed -i 's/".so,.dll"/".bundle,.so,.dll"/' \
			src/core/wee-config.c || die
	fi
}

src_configure() {
	local mycmakeargs=(
		-DLIBDIR="${EPREFIX}/usr/$(get_libdir)"
		-DENABLE_JAVASCRIPT=OFF
		-DENABLE_LARGEFILE=ON
		-DENABLE_NCURSES=ON
		-DENABLE_PHP=OFF
		-DENABLE_ALIAS=$(usex alias)
		-DENABLE_BUFLIST=$(usex buflist)
		-DENABLE_CHARSET=$(usex charset)
		# -DENABLE_DOC requires all plugins (except javascript).
		# https://github.com/weechat/weechat/blob/v4.0.2/CMakeLists.txt#L144
		# Impossible since php was dropped in net-irc/weechat-3.5.r1.ebuild. bug #705702
		-DENABLE_DOC=OFF
		-DENABLE_DOC_INCOMPLETE=$(usex doc)
		-DENABLE_ENCHANT=$(usex enchant)
		-DENABLE_EXEC=$(usex exec)
		-DENABLE_FIFO=$(usex fifo)
		-DENABLE_FSET=$(usex fset)
		-DENABLE_GUILE=$(usex guile)
		-DENABLE_IRC=$(usex irc)
		-DENABLE_LOGGER=$(usex logger)
		-DENABLE_LUA=$(usex lua)
		-DENABLE_MAN=$(usex man)
		-DENABLE_NLS=$(usex nls)
		-DENABLE_PERL=$(usex perl)
		-DENABLE_PYTHON=$(usex python)
		-DENABLE_RELAY=$(usex relay)
		-DENABLE_CJSON=$(usex relay-api)
		-DENABLE_RUBY=$(usex ruby)
		-DENABLE_SCRIPT=$(usex scripts)
		-DENABLE_SCRIPTS=$(usex scripts)
		-DENABLE_SPELL=$(usex spell)
		-DENABLE_TCL=$(usex tcl)
		-DENABLE_TESTS=$(usex test)
		-DENABLE_TRIGGER=$(usex trigger)
		-DENABLE_TYPING=$(usex typing)
		-DENABLE_XFER=$(usex xfer)
		-DENABLE_ZSTD=$(usex zstd)
	)
	cmake_src_configure
}

src_test() {
	if $(locale -a | grep -iq "en_US\.utf.*8"); then
		cmake_src_test -V
	else
		eerror "en_US.UTF-8 locale is required to run ${PN}'s ${FUNCNAME}"
		die "required locale missing"
	fi
}

src_install() {
	cmake_src_install

	use guile && guile_unstrip_ccache
}
