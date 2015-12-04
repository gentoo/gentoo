# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils versionator

SLOT="0"
PV_STRING="$(get_version_component_range 4-6)"
MY_PV="$(get_version_component_range 1-3)"
MY_PN="idea"

DESCRIPTION="A complete toolset for web, mobile and enterprise development"
HOMEPAGE="http://www.jetbrains.com/idea"
SRC_URI="http://download-cf.jetbrains.com/idea/${MY_PN}IU-${PV_STRING}.tar.gz"

LICENSE="IDEA
	|| ( IDEA_Academic IDEA_Classroom IDEA_OpenSource IDEA_Personal )"
IUSE=""
KEYWORDS="~amd64 ~x86"

DEPEND="!dev-util/${PN}:14
	!dev-util/${PN}:15"
RDEPEND="${DEPEND}
	>=virtual/jdk-1.7:*"
S="${WORKDIR}/${MY_PN}-IU-${PV_STRING}"

QA_PREBUILT="opt/${PN}-${MY_PV}/*"

src_prepare() {
	if ! use amd64; then
		rm -r plugins/tfsIntegration/lib/native/linux/x86_64 || die
	fi
	if ! use arm; then
		rm bin/fsnotifier-arm || die
		rm -r plugins/tfsIntegration/lib/native/linux/arm || die
	fi
	if ! use ppc; then
		rm -r plugins/tfsIntegration/lib/native/linux/ppc || die
	fi
	if ! use x86; then
		rm -r plugins/tfsIntegration/lib/native/linux/x86 || die
	fi
	rm -r plugins/tfsIntegration/lib/native/solaris || die
	rm -r plugins/tfsIntegration/lib/native/hpux || die
}

src_install() {
	local dir="/opt/${PN}-${MY_PV}"

	insinto "${dir}"
	doins -r *
	fperms 755 "${dir}"/bin/{idea.sh,fsnotifier{,64}}

	make_wrapper "${PN}" "${dir}/bin/${MY_PN}.sh"
	newicon "bin/${MY_PN}.png" "${PN}.png"
	make_desktop_entry "${PN}" "IntelliJ Idea Ultimate" "${PN}" "Development;IDE;"

	# recommended by: https://confluence.jetbrains.com/display/IDEADEV/Inotify+Watches+Limit
	mkdir -p "${D}/etc/sysctl.d/" || die
	echo "fs.inotify.max_user_watches = 524288" > "${D}/etc/sysctl.d/30-idea-inotify-watches.conf" || die
}
