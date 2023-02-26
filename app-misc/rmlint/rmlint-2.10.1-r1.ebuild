# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )

inherit gnome2-utils python-single-r1 scons-utils toolchain-funcs

DESCRIPTION="Extremely fast tool to remove duplicates and other lint from your filesystem"
HOMEPAGE="https://rmlint.readthedocs.io/"
SRC_URI="https://github.com/sahib/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc gui nls test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="!test? ( test )"

DEPEND="
	dev-libs/glib:2
	dev-libs/json-glib
	virtual/libelf:0=
"
RDEPEND="
	${DEPEND}
	gui? (
		${PYTHON_DEPS}
		x11-libs/gtksourceview:3.0
		$(python_gen_cond_dep '
			dev-python/colorlog[${PYTHON_USEDEP}]
			dev-python/pygobject:3[${PYTHON_USEDEP}]
		')
	)
"
BDEPEND="
	virtual/pkgconfig
	doc? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-python/sphinx[${PYTHON_USEDEP}]
			dev-python/sphinx-bootstrap-theme[${PYTHON_USEDEP}]
		')
	)
	nls? ( sys-devel/gettext )
	test? (
		${PYTHON_DEPS}
		app-shells/dash
		$(python_gen_cond_dep '
			dev-python/nose[${PYTHON_USEDEP}]
			dev-python/parameterized[${PYTHON_USEDEP}]
			dev-python/psutil[${PYTHON_USEDEP}]
			dev-python/pyxattr[${PYTHON_USEDEP}]
		')
	)
"

DOCS=(CHANGELOG.md README.rst)
PATCHES=(
	# The build system tries to override several CFLAGS
	"${FILESDIR}/${PN}-2.10.1-cflags.patch"
	# https://github.com/sahib/rmlint/pull/520
	"${FILESDIR}/${PN}-2.10.1-scons.patch"
	# https://github.com/sahib/rmlint/pull/521
	"${FILESDIR}/${PN}-2.10.1-fix-tests.patch"
	# Skip problematic tests
	"${FILESDIR}/${PN}-2.10.1-skip-tests.patch"
	# https://github.com/sahib/rmlint/pull/523
	"${FILESDIR}/${PN}-2.10.1-x86-fix-size.patch"
	# https://github.com/sahib/rmlint/pull/526
	"${FILESDIR}/${PN}-2.10.1-fix-cc.patch"
	# https://github.com/sahib/rmlint/issues/608#issuecomment-1406811107
	"${FILESDIR}/${PN}-2.10.1-fix-gui-install.patch"
)

src_prepare() {
	default
	if use test && use x86; then
		# Skip part of a test until this is fixed:
		# https://github.com/sahib/rmlint/issues/522
		sed -i '/--size 0-18446744073709551615\.1/d' \
			tests/test_options/test_size.py || die
	fi
}

src_configure() {
	# Needed for USE=-native-symlinks
	tc-export AR CC
	scons_opts=(
		VERBOSE=1
		$(use_with doc docs)
		$(use_with gui)
		$(use_with nls gettext)
	)
	escons "${scons_opts[@]}" config
}

src_compile() {
	escons "${scons_opts[@]}"
}

src_test() {
	RM_TS_DIR="${T}/tests" nosetests -s -v -a '!slow' || \
		die "Tests failed"
}

src_install() {
	escons "${scons_opts[@]}" --prefix="${ED}/usr" --actual-prefix="${EPREFIX}/usr" install

	# https://github.com/sahib/rmlint/pull/525
	if use doc; then
		gzip -d "${ED}/usr/share/man/man1/rmlint.1.gz" || die
	fi
	if use gui; then
		python_optimize
	fi
	einstalldocs
}

pkg_preinst() {
	if use gui; then
		gnome2_schemas_savelist
	fi
}

pkg_postinst() {
	if use gui; then
		gnome2_schemas_update
		xdg_icon_cache_update
	fi
}

pkg_postrm() {
	if use gui; then
		gnome2_schemas_update
		xdg_icon_cache_update
	fi
}
