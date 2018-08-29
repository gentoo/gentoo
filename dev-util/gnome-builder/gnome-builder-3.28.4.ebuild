# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_{4,5,6} )
VALA_MIN_API_VERSION="0.36"
DISABLE_AUTOFORMATTING=1
FORCE_PRINT_ELOG=1

inherit gnome.org gnome2-utils llvm meson python-single-r1 readme.gentoo-r1 vala virtualx xdg

DESCRIPTION="An IDE for writing GNOME-based software"
HOMEPAGE="https://wiki.gnome.org/Apps/Builder"

# FIXME: Review licenses at some point
LICENSE="GPL-3+ GPL-2+ LGPL-3+ LGPL-2+ MIT CC-BY-SA-3.0 CC0-1.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="clang +devhelp doc +git gtk-doc sysprof vala webkit"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# When bumping, pay attention to all the included plugins/*/meson.build (and other) build files and the requirements within.
# `grep -rI dependency * --include='meson.build'` can give a good initial idea for external deps and their double checking.
# The listed RDEPEND order shold roughly match that output as well, with toplevel one first.
# Most plugins have no extra requirements and default to enabled; we need to handle the ones with extra requirements. Many of
# them have optional runtime dependencies, for which we try to at least notify the user via DOC_CONTENTS (but not all small
# things); `grep -rI -e 'command-pattern.*=' -e 'push_arg'` can give a (spammy) idea, plus python imports in try/except.

# FIXME: with_flatpak needs flatpak.pc >=0.8.0, ${LIBGIT_DEPS} and libsoup-2.4.pc >=2.52.0
# Editorconfig needs old pcre, with vte migrating away, might want it optional or ported to pcre2?
# An introspection USE flag of a dep is required if any introspection based language plugin wants to use it (grep for gi.repository). Last full check at 3.28.4

# These are needed with either USE=git or USE=flatpak (albeit the latter isn't supported yet)
LIBGIT_DEPS="
	dev-libs/libgit2[ssh,threads]
	>=dev-libs/libgit2-glib-0.25.0[ssh]
"
# TODO: Handle llvm slots via llvm.eclass; see plugins/clang/meson.build
RDEPEND="
	>=dev-libs/libdazzle-3.28.0[introspection,vala?]
	>=dev-libs/glib-2.56.0:2
	>=x11-libs/gtk+-3.22.26:3[introspection]
	>=x11-libs/gtksourceview-3.24.0:3.0[introspection]
	>=dev-libs/json-glib-1.2.0
	>=dev-libs/jsonrpc-glib-3.28.0[vala?]
	>=x11-libs/pango-1.38.0
	>=dev-libs/libpeas-1.22.0[python,${PYTHON_USEDEP}]
	>=dev-libs/template-glib-3.28.0[introspection,vala?]
	>=x11-libs/vte-0.40.2:2.91[vala?]
	>=dev-libs/libxml2-2.9.0
	git? ( ${LIBGIT_DEPS} )
	dev-libs/libpcre:3
	webkit? ( >=net-libs/webkit-gtk-2.12.0:4=[introspection] )

	>=dev-libs/gobject-introspection-1.48.0:=
	>=dev-python/pygobject-3.22.0:3[${PYTHON_USEDEP}]
	${PYTHON_DEPS}
	clang? ( sys-devel/clang:= )
	devhelp? ( >=dev-util/devhelp-3.25.1:= )
	sysprof? ( >=dev-util/sysprof-3.28.0[gtk] )
	vala? (
		dev-lang/vala:=
		$(vala_depend)
	)
" # We use subslot operator dep on vala in addition to $(vala_depend), because we have _runtime_
#   usage in vapa-pack plugin and need it rebuilt before removing an older vala it was built against
# TODO: runtime ctags path finding..
# FIXME: spellcheck plugin temporarily disabled due to requiring enchant-2
#	>=app-text/gspell-1.2.0
#	>=app-text/enchant:2

# desktop-file-utils required for tests, but we have it in deptree for xdg update-desktop-database anyway, so be explicit and unconditional
# appstream-glib needed for appdata.xml gettext translation and validation of it with appstream-util with FEATURES=test
DEPEND="${RDEPEND}
	doc? ( dev-python/sphinx )
	dev-libs/appstream-glib
	dev-util/desktop-file-utils
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

DOC_CONTENTS='gnome-builder can use various other dependencies on runtime to provide
extra capabilities beyond these expressed via USE flags. Some of these
that are currently available with packages include:

* dev-util/uncrustify and dev-python/autopep8 for various Code Beautifier
  plugin out of the box functionality.
* dev-util/ctags with exuberant-ctags selected via "eselect ctags" for
  C, C++, Python, JavaScript, CSS, HTML and Ruby autocompletion, semantic
  highlighting and symbol resolving support.
* dev-python/jedi and dev-python/lxml for more accurate Python
  autocompletion support.
* dev-util/valgrind for integration with valgrind.
* dev-util/meson for integration with the Meson build system.
* dev-util/cargo for integration with the Rust Cargo build system.
* dev-util/cmake for integration with the CMake build system.
* net-libs/nodejs[npm] for integration with the NPM package system.
'
# FIXME: Package gnome-code-assistance and mention here, or maybe USE flag and default enable because it's rather important
# eslint for additional diagnostics in JavaScript files (what package has this? At least something via NPM..)
# jhbuild support
# rust language server via rls; Go via go-langserver
# autotools stuff for autotools plugin; gtkmm/autoconf-archive for C++ template
# gjs/gettext/mono/PHPize stuff, but most of these are probably installed for other reasons anyways, when needed inside IDE

PATCHES=(
	"${FILESDIR}"/${PV}-python37-fix.patch # async 3.7 keyword usage removal
	"${FILESDIR}"/${PV}-jedi-0.12-compat.patch # preliminary jedi-0.12 compatibility from 3.29.9x/git
	"${FILESDIR}"/${PV}-valac.patch # Make valapack honor VALAC env var - https://gitlab.gnome.org/GNOME/gnome-builder/merge_requests/109
	"${FILESDIR}"/${PV}-fix-docs-option.patch # Fix USE=doc to work without USE=gtk-doc
	"${FILESDIR}"/${PV}-fix-tests-schemadir.patch # Fix tests GSETTINGS_SCHEMA_DIR handling (or tests fail on fresh install) - https://gitlab.gnome.org/GNOME/gnome-builder/merge_requests/111
)

llvm_check_deps() {
	has_version "sys-devel/clang:${LLVM_SLOT}"
}

pkg_setup() {
	python-single-r1_pkg_setup
	use clang && llvm_pkg_setup
}

src_prepare() {
	use vala && vala_src_prepare
	xdg_src_prepare
}

src_configure() {
	local emesonargs=(
		-Denable_tracing=false
		-Denable_profiling=false # not passing -pg to CFLAGS
		-Dwith_channel=other
		-Dwith_editorconfig=true # needs libpcre
		$(meson_use webkit with_webkit)
		$(meson_use vala with_vapi)
		$(meson_use doc with_help)
		$(meson_use gtk-doc with_docs)

		$(meson_use clang with_clang)
		$(meson_use devhelp with_devhelp)
		-Dwith_deviced=false
		-Dwith_flatpak=false
		$(meson_use git with_git)
		$(meson_use webkit with_html_preview)
		-Dwith_spellcheck=false # TODO: requires enchant-2
		$(meson_use sysprof with_sysprof)
		$(meson_use vala with_vala_pack)
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	if use doc; then
		rm "${ED}"/usr/share/doc/gnome-builder/en/.buildinfo || die
		rm "${ED}"/usr/share/doc/gnome-builder/en/objects.inv || die
		rm -r "${ED}"/usr/share/doc/gnome-builder/en/.doctrees || die
		# custom docdir in build system, blocked by https://github.com/mesonbuild/meson/issues/825
		mv "${ED}"/usr/share/doc/gnome-builder/en "${ED}"/usr/share/doc/${PF}/html || die
		# _sources subdir left in on purpose, as HTML links to the rst files as "View page source". Additionally default docompress exclusion of /html/ already ensures they aren't compressed, thus linkable as-is.
		rmdir "${ED}"/usr/share/doc/gnome-builder/ || die
	fi
	readme.gentoo_create_doc
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_icon_cache_update
	gnome2_schemas_update
	readme.gentoo_print_elog
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_icon_cache_update
	gnome2_schemas_update
}

src_test() {
	# FIXME: this should be handled at meson level upstream like epiphany does
	find "${S}" -name '*.gschema.xml' -exec cp {} "${BUILD_DIR}/data/gsettings" \; || die
	"${EROOT}${GLIB_COMPILE_SCHEMAS}" --allow-any-name "${BUILD_DIR}/data/gsettings" || die

	virtx meson_src_test
}
