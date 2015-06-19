# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/hashcat-bin/hashcat-bin-0.49.ebuild,v 1.1 2015/02/28 21:59:15 alonbl Exp $

EAPI=5

MY_P="hashcat-${PV}"

inherit eutils pax-utils
DESCRIPTION="An multi-threaded multihash cracker"
HOMEPAGE="http://hashcat.net/hashcat/"

SRC_URI="http://hashcat.net/files/${MY_P}.7z"

#license applies to this version per http://hashcat.net/forum/thread-1348.html
LICENSE="hashcat"
SLOT="0"
KEYWORDS="-* ~amd64 ~amd64-linux ~x64-macos ~x86 ~x86-linux"

IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	app-arch/p7zip"

S="${WORKDIR}/${MY_P}"

RESTRICT="strip"
QA_PREBUILT="opt/${PN}/hashcat-cli*.bin
		opt/${PN}/hashcat-cli64.app"

has_xop() {
	echo | $(tc-getCC) ${CFLAGS} -E -dM - | grep -q "#define __XOP__ 1"
}

has_avx() {
	echo | $(tc-getCC) ${CFLAGS} -E -dM - | grep -q "#define __AVX__ 1"
}

src_install() {
	dodoc docs/*
	rm -r *.exe docs || die
	use x86 || { rm hashcat-cli32.bin || die; }
	use amd64 || { rm hashcat-cli64.bin || die; }
	use x64-macos || { rm hashcat-cli64.app || die; }
	has_avx || { rm hashcat-cliAVX.bin || die; }
	has_xop || { rm hashcat-cliXOP.bin || die; }

	#I assume this is needed but I didn't check
	pax-mark m hashcat-cli*.bin

	insinto /opt/${PN}
	doins -r "${S}"/*

	dodir /opt/bin
	if [ -f "${ED}"/opt/${PN}/hashcat-cli32.bin ]
	then
		fperms +x /opt/${PN}/hashcat-cli32.bin
		cat <<-EOF > "${ED}"/opt/bin/hashcat-cli32.bin
			#! /bin/sh
			cd "${EPREFIX}"/opt/${PN}
			echo "Warning: hashcat-cli32.bin is running from ${EPREFIX}/opt/${PN} so be careful of relative paths."
			exec ./hashcat-cli32.bin \$@
		EOF
		fperms +x /opt/bin/hashcat-cli32.bin
	fi
	if [ -f "${ED}"/opt/${PN}/hashcat-cli64.bin ]
	then
		fperms +x /opt/${PN}/hashcat-cli64.bin
		cat <<-EOF > "${ED}"/opt/bin/hashcat-cli64.bin
			#! /bin/sh
			cd "${EPREFIX}"/opt/${PN}
			echo "Warning: hashcat-cli64.bin is running from ${EPREFIX}/opt/${PN} so be careful of relative paths."
			exec ./hashcat-cli64.bin \$@
		EOF
		fperms +x /opt/bin/hashcat-cli64.bin
	fi
	if [ -f "${ED}"/opt/${PN}/hashcat-cliAVX.bin ]
	then
		fperms +x /opt/${PN}/hashcat-cliAVX.bin
		cat <<-EOF > "${ED}"/opt/bin/hashcat-cliAVX.bin
			#! /bin/sh
			cd "${EPREFIX}"/opt/${PN}
			echo "Warning: hashcat-cliAVX.bin is running from ${EPREFIX}/opt/${PN} so be careful of relative paths."
			exec ./hashcat-cliAVX.bin \$@
		EOF
		fperms +x /opt/bin/hashcat-cliAVX.bin
	fi
	if [ -f "${ED}"/opt/${PN}/hashcat-cliXOP.bin ]
	then
		fperms +x /opt/${PN}/hashcat-cliXOP.bin
		cat <<-EOF > "${ED}"/opt/bin/hashcat-cliXOP.bin
			#! /bin/sh
			cd "${EPREFIX}"/opt/${PN}
			echo "Warning: hashcat-cliXOP.bin is running from ${EPREFIX}/opt/${PN} so be careful of relative paths."
			exec ./hashcat-cliXOP.bin \$@
		EOF
		fperms +x /opt/bin/hashcat-cliXOP.bin
	fi
	if [ -f "${ED}"/opt/${PN}/hashcat-cli64.app ]
	then
		fperms +x /opt/${PN}/hashcat-cli64.app
		cat <<-EOF > "${ED}"/opt/bin/hashcat-cli64.app
			#! /bin/sh
			cd "${EPREFIX}"/opt/${PN}
			echo "Warning: hashcat-cli64.app is running from ${EPREFIX}/opt/${PN} so be careful of relative paths."
			exec ./hashcat-cli64.app \$@
		EOF
		fperms +x /opt/bin/hashcat-cli64.app
	fi
}
