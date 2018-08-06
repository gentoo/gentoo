# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit desktop eutils

DESCRIPTION="A complete toolset for C and C++ development"
HOMEPAGE="http://www.jetbrains.com/clion"
SRC_URI="http://download.jetbrains.com/cpp/CLion-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="IDEA
	|| ( IDEA_Academic IDEA_Classroom IDEA_OpenSource IDEA_Personal )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="splitdebug"
IUSE="-custom-jdk"

# RDEPENDS may cause false positives in repoman.
# clion requires cmake and gdb at runtime to build and debug C/C++ projects
RDEPEND="
	sys-devel/gdb
	dev-util/cmake
	!custom-jdk? ( virtual/jdk )"

QA_PREBUILT="opt/${P}/*"

src_prepare() {
	default

	local remove_me=(
		bin/gdb/linux
		bin/lldb/linux
		bin/cmake
		license/CMake*
		plugins/tfsIntegration/lib/native/hpux
		plugins/tfsIntegration/lib/native/solaris
	)

	use amd64 || remove_me+=( plugins/tfsIntegration/lib/native/linux/x86_64 )
	use arm || remove_me+=( bin/fsnotifier-arm plugins/tfsIntegration/lib/native/linux/arm )
	use ppc || remove_me+=( plugins/tfsIntegration/lib/native/linux/ppc )
	use x86 || remove_me+=( plugins/tfsIntegration/lib/native/linux/x86 )

	use custom-jdk || remove_me+=( jre64 )

	rm -rv "${remove_me[@]}" || die
}

src_install() {
	local dir="/opt/${P}"

	insinto "${dir}"
	doins -r *
	fperms 755 "${dir}"/bin/{clion.sh,fsnotifier{,64},clang/linux/clang{d,-tidy}}

	if use custom-jdk; then
		if [[ -d jre64 ]]; then
		fperms 755 "${dir}"/jre64/bin/{java,jjs,keytool,orbd,pack200,policytool,rmid,rmiregistry,servertool,tnameserv,unpack200}
		fi
	fi

	make_wrapper "${PN}" "${dir}/bin/${PN}.sh"
	newicon "bin/${PN}.svg" "${PN}.svg"
	make_desktop_entry "${PN}" "clion" "${PN}" "Development;IDE;"

	# recommended by: https://confluence.jetbrains.com/display/IDEADEV/Inotify+Watches+Limit
	dodir /usr/lib/sysctl.d/
	echo "fs.inotify.max_user_watches = 524288" > "${D}/usr/lib/sysctl.d/30-clion-inotify-watches.conf" || die
}
