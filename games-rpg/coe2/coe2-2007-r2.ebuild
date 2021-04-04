# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop wrapper

DESCRIPTION="Precursor to the Dominions series"
HOMEPAGE="https://www.shrapnelgames.com/Our_Games/Free_Games.html"
SRC_URI="https://download.shrapnelgames.com/downloads/${PN}_${PV}.zip"
S="${WORKDIR}"/coe

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror bindist"

DEPEND="media-libs/libsdl[sound,video]"
RDEPEND="
	${DEPEND}
	acct-group/gamestat
"
BDEPEND="app-arch/unzip"

# bug #430026
QA_PREBUILT="opt/coe2/coe_linux"

src_prepare() {
	default

	rm -r *.{dll,exe} old || die
	if use amd64 ; then
		mv -f coe_linux64bit coe_linux || die
	fi
}

src_install() {
	insinto /opt/${PN}
	doins *.{bgm,smp,trp,trs,wrl}
	dodoc history.txt manual.txt readme.txt
	exeinto /opt/${PN}
	doexe coe_linux

	make_wrapper ${PN} "./coe_linux" "/opt/${PN}"
	make_desktop_entry ${PN} "Conquest of Elysium 2"

	# Slots for saved games.
	# The game shows e.g. "EMPTY SLOT 0?", but it works.
	local state_dir=/var/lib/${PN}
	dodir ${state_dir}

	local f slot
	for slot in {0..4} ; do
		f=save${slot}

		dosym ${state_dir}/save${slot} /opt/${PN}/${f}
		echo "empty slot ${slot}" > "${ED}"/${state_dir}/${f} || die
		fperms 660 ${state_dir}/${f}
	done

	fowners -R root:gamestat /var/lib/${PN}/
	fperms g+s /opt/${PN}/coe_linux
}
