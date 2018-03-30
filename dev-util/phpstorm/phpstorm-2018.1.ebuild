# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit desktop eutils vcs-snapshot

DESCRIPTION="IDE for PHP built on the JetBrains IntelliJ IDEA platform"
HOMEPAGE="https://www.jetbrains.com/phpstorm/"
SRC_URI="https://download-cf.jetbrains.com/webide/PhpStorm-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( IDEA IDEA_Academic IDEA_Classroom IDEA_OpenSource IDEA_Personal )"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=virtual/jre-1.8"

QA_PREBUILT="opt/${PN}/*"

src_prepare() {
	default

	rm -r jre64 || die "failed to remove bundled JRE"

	if ! use amd64 ; then
		rm bin/fsnotifier64 || die "rm fsnotifier64 failed"
		rm bin/libyjpagent-linux64.so || die "rm libyjpagent-linux64.so failed"
	fi
	if ! use arm ; then
		rm bin/fsnotifier-arm || die "rm fsnotifier-arm failed"
	fi
	if ! use x86 ; then
		rm bin/fsnotifier || die "rm fsnotifier failed"
		rm bin/libyjpagent-linux.so || die "rm libyjpagent-linux.so failed"
	fi
}

src_install() {
	local dir="/opt/${PN}"

	insinto "${dir}"
	doins -r .

	fperms +x "${dir}"/bin/{${PN}.sh,format.sh,inspect.sh,printenv.py,restart.py}
	use amd64 && fperms +x "${dir}"/bin/fsnotifier64
	use arm && fperms +x "${dir}"/bin/fsnotifier-arm
	use x86 && fperms +x "${dir}"/bin/fsnotifier

	make_wrapper "${PN}" "${dir}/bin/${PN}.sh"
	newicon "bin/${PN}.png" "${PN}.png"
	make_desktop_entry "${PN}" "PhpStorm" "${PN}" "Development;IDE;"
}
