# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )
VALA_MIN_API_VERSION="0.36"
DISABLE_AUTOFORMATTING=1
FORCE_PRINT_ELOG=1

inherit gnome.org gnome2-utils llvm meson python-single-r1 readme.gentoo-r1 vala virtualx xdg

DESCRIPTION="An IDE for writing GNOME-based software"
HOMEPAGE="https://wiki.gnome.org/Apps/Builder"
SRC_URI+=" https://dev.gentoo.org/~leio/distfiles/${P}-patchset.tar.xz"

# FIXME: Review licenses at some point
LICENSE="GPL-3+ GPL-2+ LGPL-3+ LGPL-2+ MIT CC-BY-SA-3.0 CC0-1.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="clang +devhelp doc +git +glade gtk-doc spell sysprof test vala"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# When bumping, pay attention to all the included plugins/*/meson.build (and other) build files and the requirements within.
# `grep -rI dependency * --include='meson.build'` can give a good initial idea for external deps and their double checking.
# The listed RDEPEND order shold roughly match that output as well, with toplevel one first then sorted by file path.
# Most plugins have no extra requirements and default to enabled; we need to handle the ones with extra requirements. Many of
# them have optional runtime dependencies, for which we try to at least notify the user via DOC_CONTENTS (but not all small
# things); `grep -rI -e 'command-pattern.*=' -e 'push_arg'` can give a (spammy) idea, plus python imports in try/except.

# FIXME: plugin_flatpak needs flatpak.pc >=0.8.0, ostree-1, libsoup-2.4.pc >=2.52.0 and git plugin enabled
# Editorconfig needs old pcre, with vte migrating away, might want it optional or ported to pcre2?
# An introspection USE flag of a dep is required if any introspection based language plugin wants to use it (grep for gi.repository). Last full check at 3.28.4

# TODO: Handle llvm slots via llvm.eclass; see plugins/clang/meson.build
RDEPEND="
	>=dev-libs/libdazzle-3.33.90[introspection,vala?]
	>=dev-libs/glib-2.61.2:2
	>=x11-libs/gtk+-3.22.26:3[introspection]
	>=x11-libs/gtksourceview-4.0.0:4[introspection]
	>=dev-libs/json-glib-1.2.0
	>=dev-libs/jsonrpc-glib-3.19.91[vala?]
	>=x11-libs/pango-1.38.0
	>=dev-libs/libpeas-1.22.0[python,${PYTHON_SINGLE_USEDEP}]
	>=dev-libs/template-glib-3.28.0[introspection,vala?]
	>=x11-libs/vte-0.40.2:2.91[introspection,vala?]
	>=net-libs/webkit-gtk-2.12.0:4=[introspection]
	>=dev-libs/libxml2-2.9.0
	git? ( dev-libs/libgit2[ssh,threads]
		>=dev-libs/libgit2-glib-0.28.0.1[ssh]
	)
	dev-libs/libpcre:3
	dev-libs/libpcre2

	>=dev-libs/gobject-introspection-1.54.0:=
	$(python_gen_cond_dep '
		>=dev-python/pygobject-3.22.0:3[${PYTHON_MULTI_USEDEP}]
	')
	${PYTHON_DEPS}
	clang? ( sys-devel/clang:= )
	devhelp? ( >=dev-util/devhelp-3.25.1:= )
	glade? ( >=dev-util/glade-3.22.0:3.10 )
	spell? ( >=app-text/gspell-1.8:0=
		app-text/enchant:2 )
	>=dev-util/sysprof-capture-3.33.1:3
	sysprof? ( >=dev-util/sysprof-3.33.4:0/3[gtk] )
	vala? (
		dev-lang/vala:=
		$(vala_depend)
	)
" # We use subslot operator dep on vala in addition to $(vala_depend), because we have _runtime_
#   usage in vala-pack plugin and need it rebuilt before removing an older vala it was built against
DEPEND="${RDEPEND}"
# TODO: runtime ctags path finding..

# desktop-file-utils required for tests, but we have it in deptree for xdg update-desktop-database anyway, so be explicit and unconditional
# appstream-glib needed for validation with appstream-util with FEATURES=test
BDEPEND="
	doc? ( dev-python/sphinx
		dev-python/sphinx_rtd_theme )
	gtk-doc? ( dev-util/gtk-doc
		app-text/docbook-xml-dtd:4.3 )
	test? (
		dev-libs/appstream-glib
		sys-apps/dbus )
	dev-util/desktop-file-utils
	dev-util/glib-utils
	>=dev-util/meson-0.49.2
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
	"${WORKDIR}/patches" # gnome-builder-3-34 branch 2020-01-22 (commit bf485934b37) + cherry-picked meson link_whole fixes
	"${FILESDIR}"/${PV}-optional-vala.patch
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
		-Dtracing=false
		-Dprofiling=false # not passing -pg to CFLAGS
		-Dfusermount_wrapper=false # meant for flatpak builds
		-Dtcmalloc=false
		-Dchannel=other

		$(meson_use vala vapi) # TODO: doesn't work anymore; crude patch included
		$(meson_use doc help)
		$(meson_use gtk-doc docs)

		-Dnetwork_tests=false
		$(meson_use clang plugin_clang)
		$(meson_use devhelp plugin_devhelp)
		-Dplugin_deviced=false
		-Dplugin_editorconfig=true # needs libpcre
		-Dplugin_flatpak=false
		$(meson_use git plugin_git)
		$(meson_use glade plugin_glade)
		-Dplugin_podman=false
		$(meson_use spell plugin_spellcheck)
		$(meson_use sysprof plugin_sysprof)
		$(meson_use vala plugin_vala)
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	python_optimize
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
	gnome2_schemas_update
	readme.gentoo_print_elog
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}

src_test() {
	# FIXME: can't run meson_src_test together with virtx or dbus-run-session
	virtx dbus-run-session meson test -C "${BUILD_DIR}"
}
