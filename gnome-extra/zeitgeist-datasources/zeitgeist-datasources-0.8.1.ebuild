# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=true
VALA_MIN_API_VERSION=0.14
PYTHON_COMPAT=( python2_7  )

inherit autotools-utils eutils mono-env multilib python-single-r1 versionator vala

DIR_PV=$(get_version_component_range 1-2)
DIR_PV2=$(get_version_component_range 1-3)

DESCRIPTION="Plugins whose work is to push activities as events into Zeitgeist daemon"
HOMEPAGE="https://launchpad.net/zeitgeist-datasources/ http://zeitgeist-project.com/"
SRC_URI="https://launchpad.net/zeitgeist-datasources/${DIR_PV}/${DIR_PV2}/+download/${P}.tar.gz"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc x86 ~amd64-linux ~x86-linux"
LICENSE="GPL-3"
PLUGINS_IUSE="bzr chromium emacs firefox geany mono telepathy thunderbird tomboy vim"
PLUGINS="bzr chrome emacs firefox geany monodevelop telepathy thunderbird tomboy vim"
IUSE="${PLUGINS_IUSE} static-libs"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	dev-libs/libzeitgeist
	x11-libs/gtk+:2
	emacs? ( virtual/emacs )
	firefox? ( || ( >=www-client/firefox-4.0 >=www-client/firefox-bin-4.0 ) )
	geany? ( dev-util/geany )
	mono? ( dev-util/monodevelop )
	telepathy? (
		net-libs/telepathy-glib[${PYTHON_USEDEP}]
		dev-python/dbus-python[${PYTHON_USEDEP}]
		dev-python/pygobject[${PYTHON_USEDEP}]
		)
	tomboy? (
		app-misc/tomboy
		dev-dotnet/gtk-sharp
		dev-dotnet/mono-addins
		dev-dotnet/zeitgeist-sharp
		dev-python/dbus-python[${PYTHON_USEDEP}]
		)
	vim? ( app-editors/vim[python] )
"
DEPEND="${RDEPEND}
	$(vala_depend)"
PDEPEND="gnome-extra/zeitgeist"

src_prepare() {
	rm bzr/bzr-icon-64.png || die
	sed \
		-e '/bzr-icon-64.png/d' \
		-i bzr/Makefile.am || die
	sed \
		-e '/^allowed_plugin/s:^:#:g' \
		-i configure.ac || die

	SEARCH='$(datadir)/opt/google/chrome/resources'
	REPLACE="/usr/$(get_libdir)/chromium-browser/resources"
	sed \
		-e "s:${SEARCH}:${REPLACE}:" \
		-i chrome/Makefile.* || die

	sed \
		-e "/^extensiondir/s:= .*:= \$(libdir)/firefox/extensions:g" \
		-e "/^xul_extdir/s:xul-ext-zeitgeist:xpcom-firefox@zeitgeist-project.com:g" \
		-i firefox/extension/Makefile.am || die

	sed \
		-e "/^extensiondir/s:= .*:= \$(libdir)/thunderbird/extensions:g" \
		-e "/^xul_extdir/s:xul-ext-zeitgeist:thunderbird@zeitgeist-project.com:g" \
		-i thunderbird/extension/Makefile.am || die

	sed \
		-e 's:vim72:vimfiles:' \
		-i vim/Makefile.* || die

	vala_src_prepare
	autotools-utils_src_prepare
}

src_configure() {
	local i myplugins

	for i in ${PLUGINS}; do
		case ${i} in
			chrome )
				use chromium && myplugins+=( ${i} )
				;;
			monodevelop )
				use mono && myplugins+=( ${i} )
				;;
			* )
				use ${i} && myplugins+=( ${i} )
				;;
		esac
	done

	local myeconfargs=(
		allowed_plugins="${myplugins[@]}"
		)
	autotools-utils_src_configure
}
