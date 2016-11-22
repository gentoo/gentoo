# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils versionator

SLOT="0"
PV_STRING="$(get_version_component_range 4-6)"
MY_PV="$(get_version_component_range 1-3)"

SRC_URI="http://download.jetbrains.com/cpp/CLion-${MY_PV}.tar.gz -> ${PN}-${MY_PV}.tar.gz"
DESCRIPTION="A complete toolset for C and C++ development"
HOMEPAGE="http://www.jetbrains.com/clion"

KEYWORDS="~amd64 ~x86"
LICENSE="IDEA
	|| ( IDEA_Academic IDEA_Classroom IDEA_OpenSource IDEA_Personal )"

IUSE=""

RDEPEND="
	${DEPEND}
	sys-devel/gdb
	dev-util/cmake"

S="${WORKDIR}/${PN}-${MY_PV}"

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

	local REMOVE_ME=(
		bin/gdb
	    bin/cmake
	    license/GDB*
	    license/CMake*
		plugins/tfsIntegration/lib/native/hpux
		plugins/tfsIntegration/lib/native/solaris
	)

	rm -r "${REMOVE_ME[@]}" || die
}

src_install() {
	local dir="/opt/${PN}-${MY_PV}"

	insinto "${dir}"
	doins -r *
	fperms 755 "${dir}"/bin/{clion.sh,fsnotifier{,64}}

	make_wrapper "${PN}" "${dir}/bin/${PN}.sh"
	newicon "bin/${PN}.svg" "${PN}.svg"
	make_desktop_entry "${PN}" "clion" "${PN}" "Development;IDE;"

	# recommended by: https://confluence.jetbrains.com/display/IDEADEV/Inotify+Watches+Limit
	mkdir -p "${D}/etc/sysctl.d/" || die
	echo "fs.inotify.max_user_watches = 524288" > "${D}/etc/sysctl.d/30-idea-inotify-watches.conf" || die
}
