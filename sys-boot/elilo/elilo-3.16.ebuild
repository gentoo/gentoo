# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit toolchain-funcs eutils multilib

DESCRIPTION="Linux boot loader for EFI-based systems such as IA-64"
HOMEPAGE="https://sourceforge.net/projects/elilo/"
SRC_URI="mirror://sourceforge/elilo/${P}-all.tar.gz
	mirror://debian/pool/main/e/elilo/elilo_3.14-3.debian.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~x86"
IUSE=""

# gnu-efi contains only static libs, so there's no run-time dep on it
DEPEND=">=sys-boot/gnu-efi-3.0g
	dev-util/patchutils"
RDEPEND="sys-boot/efibootmgr
	sys-fs/dosfstools"

S="${WORKDIR}/${P}-source"

src_unpack() {
	unpack ${A} ./${P}-source.tar.gz
	mv debian "${S}"/ || die
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-3.16-elilo-loop.patch #299665

	# The patches Debian had were merged upstream.
	#epatch debian/patches/*.diff

	case $(tc-arch) in
	ia64)  iarch=ia64 ;;
	x86)   iarch=ia32 ;;
	amd64) iarch=x86_64 ;;
	*)     die "unknown architecture: $(tc-arch)" ;;
	esac

	# Now Gentooize it.
	sed -i \
		-e '1s:/bin/sh:/bin/bash:' \
		-e "s:##VERSION##:${PV}:" \
		-e 's:Debian GNU/:Gentoo :g' \
		-e 's:Debian:Gentoo:g' \
		-e 's:debian:gentoo:g' \
		-e "s:dpkg --print-architecture:echo ${iarch}:" \
		debian/elilo.sh || die
}

src_compile() {
	# "prefix" on the next line specifies where to find gcc, as, ld,
	# etc.  It's not the usual meaning of "prefix".  By blanking it we
	# allow PATH to be searched.
	local libdir="${SYSROOT}${EPREFIX}/usr/$(get_libdir)"
	emake -j1 \
		prefix= \
		AS="$(tc-getAS)" \
		CC="$(tc-getCC)" \
		LD="$(tc-getLD)" \
		HOSTARCH=${iarch} \
		ARCH=${iarch} \
		EFIINC="${SYSROOT}${EPREFIX}/usr/include/efi" \
		GNUEFILIB="${libdir}" \
		EFILIB="${libdir}" \
		EFICRT0="${libdir}"
}

src_install() {
	exeinto /usr/lib/elilo
	doexe elilo.efi

	newsbin debian/elilo.sh elilo
	dosbin tools/eliloalt

	insinto /etc
	newins "${FILESDIR}"/elilo.conf.sample elilo.conf

	dodoc docs/* "${FILESDIR}"/elilo.conf.sample
	doman debian/*.[0-9]
}
