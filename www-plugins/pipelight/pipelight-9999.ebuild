# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-plugins/pipelight/pipelight-9999.ebuild,v 1.7 2014/08/09 17:37:00 ryao Exp $

EAPI=5

inherit multilib

if [ ${PV} == "9999" ] ; then
	inherit git-2
	EGIT_REPO_URI="https://bitbucket.org/mmueller2012/${PN}.git"
else
	inherit vcs-snapshot
	SRC_URI="https://bitbucket.org/mmueller2012/${PN}/get/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Wine-based wrapper for running Windows plugins on POSIX systems"
HOMEPAGE="https://launchpad.net/pipelight"

LICENSE="|| ( GPL-2+ LGPL-2.1+ MPL-1.1 )"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="app-emulation/wine[X,abi_x86_32,pipelight]"
RDEPEND="${DEPEND}
	app-arch/cabextract
	gnome-extra/zenity"

QA_FLAGS_IGNORED="usr/share/pipelight/pluginloader.exe
	usr/share/pipelight/winecheck.exe"

src_configure() {
	econf --wine-path="${EPREFIX}/usr/bin/wine"
}

src_install() {
	default_src_install

	# Ideally, every wrapped plugin could be a symlink to pipelight's wrapper
	# plugin, but some browsers do not like this. Upstream provides a script to
	# duplicate the wrapper plugin as a hack to work around it.  That script
	# does not support DESTDIR, so we use sed to adjust it before running it to
	# properly duplicate the plugins.
	# XXX: Patch the script to support DESTDIR and send the patch upstream.
	sed -e "s:^\(PIPELIGHT_LIBRARY_PATH=\"\)\\(.*\):\1${ED}usr/$(get_libdir)/${PN}\":" \
		-e "s:^\(PLUGIN_PATH=\"\)\\(.*\):\1${ED}usr/$(get_libdir)/${PN}\":" \
		"${ED}/usr/bin/pipelight-plugin" > "${T}/pipelight-plugin" \
		|| die "Generating temporary pipelight-plugin failed"
	chmod u+x "${T}/pipelight-plugin" \
		|| die "Setting permissions on temporary pipelight-plugin failed"

	# Create Plugins
	"${T}/pipelight-plugin" --create-mozilla-plugins \
		|| die "Creating plugins failed"

}

postinst() {
	# Obligatory warnings about proprietary software
	ewarn "Neither the Gentoo developers nor the Pipelight developers can"
	ewarn "patch security vulnerabilities in Windows plugins. Use them at your"
	ewarn "own risk."
	# Warn about missing pipelight-sandbox
	ewarn
	ewarn "The pipelight sandbox has not been packaged yet. Plugins will have"
	ewarn "full privileges as Windows programs running inside wine."

	# Helpful information for those willing to live dangerously
	einfo "Using Windows plugins on certain websites might require a useragent"
	einfo "switcher. See the upstream tutorial for more details."
	einfo
	einfo "http://www.pipelight.net/cms/installation-user-agent.html"
	einfo
	einfo "End users should use the pipelight-plugin utility to install and"
	einfo "manage plugins. Updates are done at plugin initialization whenever"
	einfo "/usr/share/pipelight/install-dependency has been updated. This can"
	einfo "be done either by doing updates via portage or by running"
	einfo "pipelight-plugin --update as root. Browsers like Chrome (all"
	einfo "versions before 35) will initialize plugins at boot while browsers"
	einfo "like Firefox will initialize plugins on demand."
	einfo
	# Users must be in the video group for video acceleration
	einfo "Membership in the video group is required for using plugins that"
	einfo "feature hardware acceleration for video decoding. This is important"
	einfo "for video streaming sites that use Silverlight."
}
