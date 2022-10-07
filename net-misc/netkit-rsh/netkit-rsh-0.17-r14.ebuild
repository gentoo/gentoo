# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit pam toolchain-funcs fcaps

DESCRIPTION="Netkit's Remote Shell Suite: rexec{,d} rlogin{,d} rsh{,d}"
HOMEPAGE="https://wiki.linuxfoundation.org/networking/netkit"
SRC_URI="http://ftp.linux.org.uk/pub/linux/Networking/netkit/${P}.tar.gz
	mirror://gentoo/rexec-1.5.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE="pam"

RDEPEND="
	sys-libs/ncurses:=
	virtual/libcrypt:=
	pam? ( >=sys-auth/pambase-20080219.1 )"
DEPEND="${RDEPEND}"
BDEPEND="app-arch/xz-utils"

PATCHES=(
	"${FILESDIR}"/patches/
)

FILECAPS=( cap_net_bind_service usr/bin/r{cp,login,sh} )

src_prepare() {
	# This must happen before patches are applied
	rm -r rexec || die
	mv ../rexec rexec || die

	default

	if tc-is-cross-compiler ; then
		# Can't do runtime tests when cross-compiling
		sed -i -e "s|./__conftest|: ./__conftest|" configure || die
	fi
}

src_configure() {
	tc-export CC
	${CONFIG_SHELL:-/bin/sh} ./configure $(usex pam '' '--without-pam') || die

	sed -i \
		-e "s|-pipe -O2|${CFLAGS}|" \
		-e "/^LDFLAGS=$/d" \
		-e "s|-Wpointer-arith||" \
		MCONFIG || die
}

src_install() {
	insinto /etc/xinetd.d

	local b
	for b in rcp rexec{,d} rlogin{,d} rsh{,d} ; do
		if [[ ${b} == *d ]] ; then
			dosbin ${b}/${b}
			dosym ${b} /usr/sbin/in.${b}
			doman ${b}/${b}.8
		else
			dobin ${b}/${b}
			doman ${b}/${b}.1
			if [[ ${b} != rcp ]]; then
				newins "${FILESDIR}"/${b}.xinetd ${b}

				if use pam; then
					newpamd "${FILESDIR}/${b}.pamd-pambase" ${b}
				fi
			fi
		fi
	done

	dodoc README ChangeLog BUGS
	newdoc rexec/README README.rexec
}
