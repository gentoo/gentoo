# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic toolchain-funcs pax-utils

DESCRIPTION="Fast password cracker, community enhanced version"
HOMEPAGE="http://www.openwall.com/john/"

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/openwall/john.git"
	EGIT_BRANCH="bleeding-jumbo"
	inherit git-r3
else
	HASH_COMMIT="8a72b12fe6e1626ef6014e5a190b9d1f69a9edde"
	SRC_URI="https://github.com/openwall/john/archive/${HASH_COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/john-${HASH_COMMIT}"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
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
	virtual/zlib:=
	app-arch/bzip2"
# Missing (unpackaged):
# - Digest::Haval256
# - Digest::x
# See bug #777369.
RDEPEND="${DEPEND}
	dev-perl/Compress-Raw-Lzma
	dev-perl/Digest-MD2
	virtual/perl-Digest-MD5
	dev-perl/Digest-SHA3
	dev-perl/Digest-GOST
	!app-crypt/johntheripper"
RESTRICT="test"

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

	if ! use custom-cflags ; then
		strip-flags

		# Nasty (and incomplete) workaround for bug #729422
		filter-flags '-march=native'
		append-flags $(test-flags-CC '-mno-avx')
	fi

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

	# this probably causes the following failure:
	# Testing: as400-des, AS/400 DES [DES 32/64]... PASS
	# Error, Invalid signature line trying to link to dynamic format.
	# Original format=as400-ssha1
	sed '/.include /d' run/john.conf > run/john-test.conf
	if use opencl; then
		# GPU tests fail in portage, so run cpu only tests
		./run/john --config=run/john-test.conf --device=cpu --test=0 --verbosity=2 || die
	else
		# Weak tests
		./run/john --config=run/john-test.conf --test=0 --verbosity=2 || die
		# Strong tests
		#./run/john --test=1 --verbosity=2 || die
	fi

	rm john-test.conf || die
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
	rm -f doc/README doc/LICENSE || die
	dodoc -r README.md LICENSE doc/*
}
