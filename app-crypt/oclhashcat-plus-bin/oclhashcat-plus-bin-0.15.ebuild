# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/oclhashcat-plus-bin/oclhashcat-plus-bin-0.15.ebuild,v 1.1 2013/08/25 05:08:17 zerochaos Exp $

EAPI=5

inherit eutils pax-utils

DESCRIPTION="An opencl multihash cracker"
HOMEPAGE="http://hashcat.net/oclhashcat-plus/"

MY_P="oclHashcat-plus-${PV}"
SRC_URI="http://hashcat.net/files/${MY_P}.7z"

LICENSE="hashcat"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"

IUSE_VIDEO_CARDS="video_cards_fglrx
	video_cards_nvidia"

IUSE="virtualcl ${IUSE_VIDEO_CARDS}"

RDEPEND="sys-libs/zlib
	video_cards_nvidia? ( >=x11-drivers/nvidia-drivers-319.37 )
	video_cards_fglrx?  ( >=x11-drivers/ati-drivers-13.4 )"
DEPEND="${RDEPEND}
	app-arch/p7zip"

S="${WORKDIR}/${MY_P}"

RESTRICT="strip"
QA_PREBUILT="*Hashcat-plus*.bin
	    opt/${PN}/kernels/4098/*.llvmir"

src_prepare() {
	use x86 && rm *Hashcat-plus64*
	use amd64 && rm *Hashcat-plus32*
	use virtualcl || rm vclHashcat-plus*

	if ! use video_cards_fglrx; then
		rm -r kernels/4098 || die
		rm oclHashcat-plus*.bin || die
	fi
	if ! use video_cards_nvidia; then
		rm -r kernels/4318 || die
		rm cudaHashcat-plus*.bin || die
	fi

	#paxmark goes here so test and install works
	pax-mark r *Hashcat-plus*.bin
}

src_test() {
	printf "%02x" ${PV#0.} > "${S}"/eula.accepted
	if use video_cards_nvidia; then
		addwrite /dev/nvidia0
		addwrite /dev/nvidiactl
		if [ ! -w /dev/nvidia0 ]; then
			einfo "To run these tests, portage likely must be in the video group."
			einfo "Please run \"gpasswd -a portage video\" if the tests will fail"
		fi
		if use amd64; then
			./cudaHashcat-plus64.bin -a 3 -m 1500 nQCk49SiErOgk || die
		elif use x86; then
			./cudaHashcat-plus32.bin -a 3 -m 1500 nQCk49SiErOgk || die
		fi
	fi
	if use video_cards_fglrx; then
		addwrite /dev/ati
		if use amd64; then
			./oclHashcat-plus64.bin -a 3 -m 1500 nQCk49SiErOgk || die
		elif use x86; then
			./oclHashcat-plus32.bin -a 3 -m 1500 nQCk49SiErOgk || die
		fi
	fi
	rm eula.accepted hashcat.pot hashcat.dictstat
}

src_install() {
	dodoc docs/*
	rm -r "${S}"/*.exe "${S}"/*.cmd "${S}"/docs || die

	insinto /opt/${PN}
	doins -r "${S}"/* || die "Copy files failed"

	dodir /opt/bin

	cat <<-EOF > "${ED}"/opt/bin/oclhashcat-plus
		#! /bin/sh
		echo "oclHashcat-plus and all related files have been installed in /opt/${PN}"
		echo "Please run one of the following binaries to use gpu accelerated hashcat:"
	EOF

	for x in oclHashcat-plus64.bin oclHashcat-plus32.bin cudaHashcat-plus64.bin cudaHashcat-plus32.bin vclHashcat-plus64.bin vclHashcat-plus32.bin
	do
		if [ -f "${ED}"/opt/${PN}/${x} ]
		then
			case "${x}" in
				oclHashcat-plus64.bin)
					echo "echo '64 bit ATI accelerated \"oclHashcat-plus64.bin\"'" >> "${ED}"/opt/bin/oclhashcat-plus
					;;
				oclHashcat-plus32.bin)
					echo "echo '32 bit ATI accelerated \"oclHashcat-plus32.bin\"'" >> "${ED}"/opt/bin/oclhashcat-plus
					;;
				cudaHashcat-plus64.bin)
					echo "echo '64 bit NVIDIA accelerated \"cudaHashcat-plus64.bin\"'" >> "${ED}"/opt/bin/oclhashcat-plus
					;;
				cudaHashcat-plus32.bin)
					echo "echo '32 bit NVIDIA accelerated \"cudaHashcat-plus32.bin\"'" >> "${ED}"/opt/bin/oclhashcat-plus
					;;
				vclHashcat-plus64.bin)
					echo "echo '64 bit VirtualCL Cluster support \"vclHashcat-plus64.bin\"'" >> "${ED}"/opt/bin/oclhashcat-plus
					;;
				vclHashcat-plus32.bin)
					echo "echo '32 bit VirtualCL Cluster support \"vclHashcat-plus32.bin\"'" >> "${ED}"/opt/bin/oclhashcat-plus
					;;
			esac

			fperms +x /opt/${PN}/${x}

			cat <<-EOF > "${ED}"/opt/bin/${x}
				#! /bin/sh
				cd /opt/${PN}
				echo "Warning: ${x} is running from /opt/${PN} so be careful of relative paths."
				exec ./${x} "\$@"
			EOF

			fperms +x /opt/bin/${x}

		fi
	done

	fperms +x /opt/bin/oclhashcat-plus
	fowners -R root:video /opt/${PN}
	fperms g+w /opt/${PN}
	einfo "oclhashcat-plus can be run as user if you are in the video group"
}

pkg_preinst() {
	#I feel so dirty doing this
	#first we remove the eula.accepted because it cannot properly handle and empty or old one (crash or doesn't run at all)
	rm -f "${EROOT}"/opt/${PN}/eula.accepted
	#next we remove any compiled kernel files as these get built on first run only if they aren't there because there are no timestamp checks
	rm -f "${EROOT}"/opt/${PN}/kernels/{4318,4098}/"*.kernel"
	#have mercy on my soul
}
