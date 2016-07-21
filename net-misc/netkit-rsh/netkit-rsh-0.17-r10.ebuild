# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit eutils pam toolchain-funcs fcaps

PATCHVER="3"
DESCRIPTION="Netkit's Remote Shell Suite: rexec{,d} rlogin{,d} rsh{,d}"
HOMEPAGE="ftp://ftp.uk.linux.org/pub/linux/Networking/netkit/"
SRC_URI="ftp://ftp.uk.linux.org/pub/linux/Networking/netkit/${P}.tar.gz
	mirror://gentoo/rexec-1.5.tar.gz
	mirror://gentoo/${P}-patches-${PATCHVER}.tar.lzma"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE="pam"

RDEPEND=">=sys-libs/ncurses-5.2
	pam? ( >=sys-auth/pambase-20080219.1 )"
DEPEND="${RDEPEND}
	app-arch/xz-utils"

FILECAPS=(
	cap_net_bind_service usr/bin/r{cp,login,sh}
)

src_unpack() {
	default

	cd "${S}"
	rm -rf rexec
	mv ../rexec rexec
}

src_prepare() {
	[[ -n ${PATCHVER} ]] && EPATCH_SUFFIX="patch" epatch "${WORKDIR}"/patch

	if tc-is-cross-compiler ; then
		# Can't do runtime tests when cross-compiling
		sed -i -e "s|./__conftest|: ./__conftest|" configure
	fi
}

src_configure() {
	tc-export CC
	./configure $(usex pam '' '--without-pam') || die

	sed -i \
		-e "s:-pipe -O2:${CFLAGS}:" \
		-e "/^LDFLAGS=$/d" \
		-e "s:-Wpointer-arith::" \
		MCONFIG || die
}

src_install() {
	local b exe
	insinto /etc/xinetd.d
	for b in rcp rexec{,d} rlogin{,d} rsh{,d} ; do
		if [[ ${b} == *d ]] ; then
			dosbin ${b}/${b}
			dosym ${b} /usr/sbin/in.${b}
			doman ${b}/${b}.8
		else
			dobin ${b}/${b}
			doman ${b}/${b}.1
			if [[ ${b} != "rcp" ]]; then
				newins "${FILESDIR}"/${b}.xinetd ${b}
				newpamd "${FILESDIR}/${b}.pamd-pambase" ${b}
			fi
		fi
	done
	dodoc README ChangeLog BUGS
	newdoc rexec/README README.rexec
}
