# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs pax-utils

DESCRIPTION="fast password cracker"
HOMEPAGE="http://www.openwall.com/john/"

MY_PN="JohnTheRipper"

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/magnumripper/${MY_PN}.git"
	inherit git-r3
	KEYWORDS=""
else
	JUMBO="jumbo-1"
	MY_PV="${PV}-${JUMBO}"
	MY_P="${MY_PN}-${MY_PV}"
	SRC_URI="https://github.com/magnumripper/${MY_PN}/archive/${MY_PV}.tar.gz -> ${MY_P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
	S="${WORKDIR}/${MY_P}"
fi

LICENSE="GPL-2"
SLOT="0"
#removed rexgen and commoncrypto
IUSE="custom-cflags kerberos mpi opencl openmp pcap"

DEPEND=">=dev-libs/openssl-1.0.1:0
	mpi? ( virtual/mpi )
	opencl? ( virtual/opencl )
	kerberos? ( virtual/krb5 )
	pcap? ( net-libs/libpcap )
	dev-libs/gmp:*
	sys-libs/zlib
	app-arch/bzip2"

RDEPEND="${DEPEND}
		!app-crypt/johntheripper"

pkg_setup() {
	if use openmp && [[ ${MERGE_TYPE} != binary ]]; then
		tc-has-openmp || die "Please switch to an openmp compatible compiler"
	fi
}

src_prepare() {
	eapply "${FILESDIR}/${PV}-gcc5.patch"
	sed -i 's#/usr/share/john#/etc/john#' src/params.h || die
	default
}

src_configure() {
	cd src || die

	use custom-cflags || strip-flags

	# John ignores CPPFLAGS, use CFLAGS instead
	append-cflags -DJOHN_SYSTEMWIDE=1

	econf \
		--disable-native-macro \
		--disable-native-tests \
		--without-commoncrypto \
		--disable-rexgen \
		--with-openssl \
		$(use_enable mpi) \
		$(use_enable opencl) \
		$(use_enable openmp) \
		$(use_enable pcap)
}

src_compile() {
	emake -C src
}

src_test() {
	pax-mark -mr run/john
	#if use opencl; then
		#gpu tests fail in portage, so run cpu only tests
	#	./run/john --device=cpu --test=0 --verbosity=2 || die
	#else
		#weak tests
	#	./run/john --test=0 --verbosity=2 || die
		#strong tests
		#./run/john --test=1 --verbosity=2 || die
	#fi
	ewarn "When built systemwide, john can't run tests without reading files in /etc."
	ewarn "Don't bother opening a bug for this unless you include a patch to fix it"
}

src_install() {
	# executables
	dosbin run/john
	newsbin run/mailer john-mailer

	pax-mark -mr "${ED}/usr/sbin/john"

	# grep '$(LN)' Makefile.in | head -n-3 | tail -n+2 | cut -d' ' -f3 | cut -d/ -f3
	for s in \
		unshadow unafs undrop unique ssh2john putty2john pfx2john keepass2john keyring2john \
		zip2john gpg2john rar2john racf2john keychain2john kwallet2john pwsafe2john dmg2john \
		hccap2john base64conv truecrypt_volume2john keystore2john
	do
		dosym john /usr/sbin/$s
	done

	insinto /usr/share/john
	doins run/*.py

	if use opencl; then
		insinto /etc/john
		doins -r run/kernels
	fi

	# config files
	insinto /etc/john
	doins run/*.chr run/password.lst
	doins run/*.conf

	# documentation
	dodoc doc/*
}
