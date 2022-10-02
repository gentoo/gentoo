# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic toolchain-funcs pax-utils

DESCRIPTION="Fast password cracker"
HOMEPAGE="http://www.openwall.com/john/"

MY_PN="JohnTheRipper"

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/magnumripper/${MY_PN}.git"
	inherit git-r3
else
	JUMBO="jumbo-1.1"
	MY_PV="${PV}-${JUMBO}"
	MY_P="john-${MY_PV}"
	HASH_COMMIT="5d0c85f16f96ca7b6dd06640e95a5801081d6e20"

	SRC_URI="https://github.com/openwall/john/archive/${HASH_COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/john-${HASH_COMMIT}"

	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="custom-cflags kerberos mpi opencl openmp pcap"

DEPEND=">=dev-libs/openssl-1.0.1:=
	virtual/libcrypt:=
	mpi? ( virtual/mpi )
	opencl? ( virtual/opencl )
	kerberos? ( virtual/krb5 )
	pcap? ( net-libs/libpcap )
	dev-libs/gmp:=
	sys-libs/zlib
	app-arch/bzip2"
# Missing (unpackaged):
# - Digest::Haval256
# - Digest::x
# See bug #777369.
RDEPEND="${DEPEND}
	dev-perl/Digest-MD2
	virtual/perl-Digest-MD5
	dev-perl/Digest-SHA3
	dev-perl/Digest-GOST
	!app-crypt/johntheripper"

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_prepare() {
	default

	cd src || die
	eautoreconf

	sed -i 's#$prefix/share/john#/etc/john#' configure || die
}

src_configure() {
	cd src || die

	use custom-cflags || strip-flags

	econf \
		--enable-pkg-config \
		--disable-native-march \
		--disable-native-tests \
		--disable-rexgen \
		--with-openssl \
		--with-systemwide \
		$(use_enable mpi) \
		$(use_enable opencl) \
		$(use_enable openmp) \
		$(use_enable pcap)
}

src_compile() {
	# Uses default LD=$(CC) but if the user's set LD, it'll call it
	# bug #729432.
	emake LD="$(tc-getCC)" -C src
}

src_test() {
	pax-mark -mr run/john

	#if use opencl; then
		# GPU tests fail in portage, so run cpu only tests
	#	./run/john --device=cpu --test=0 --verbosity=2 || die
	#else
		# Weak tests
		#./run/john --test=0 --verbosity=2 || die
		# Strong tests
		#./run/john --test=1 --verbosity=2 || die
	#fi

	ewarn "When built systemwide, john can't run tests without reading files in /etc."
	ewarn "Don't bother opening a bug for this unless you include a patch to fix it"
}

src_install() {
	# Executables
	dosbin run/john
	newsbin run/mailer john-mailer

	pax-mark -mr "${ED}/usr/sbin/john"

	# grep '$(LN)' Makefile.in | head -n-3 | tail -n+2 | cut -d' ' -f3 | cut -d/ -f3
	local s
	for s in \
		unshadow unafs undrop unique ssh2john putty2john pfx2john keepass2john keyring2john \
		zip2john gpg2john rar2john racf2john keychain2john kwallet2john pwsafe2john dmg2john \
		hccap2john base64conv truecrypt_volume2john keystore2john
	do
		dosym john /usr/sbin/${s}
	done

	# Scripts
	exeinto /usr/share/john
	doexe run/*.pl
	doexe run/*.py
	insinto /usr/share/john
	doins -r run/lib
	cd run || die

	local s
	for s in *.pl *.py; do
		dosym ../share/john/${s} /usr/bin/${s}
	done
	cd .. || die

	if use opencl; then
		insinto /etc/john
		doins -r run/opencl
	fi

	# Config files
	insinto /etc/john
	doins run/*.chr run/password.lst
	doins run/*.conf
	doins -r run/rules run/ztex

	# Documentation
	rm -f doc/README || die
	dodoc -r README.md doc/*
}
