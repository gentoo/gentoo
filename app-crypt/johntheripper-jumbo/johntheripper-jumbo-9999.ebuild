# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools shell-completion toolchain-funcs pax-utils

DESCRIPTION="Fast password cracker, community enhanced version"
HOMEPAGE="http://www.openwall.com/john/"

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/openwall/john.git"
	EGIT_BRANCH="bleeding-jumbo"
	inherit git-r3
else
	HASH_COMMIT="b27f951a8e191210685c8421c90ca610cdd39dce"
	SRC_URI="https://github.com/openwall/john/archive/${HASH_COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/john-${HASH_COMMIT}"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
fi

LICENSE="GPL-2"
SLOT="0"

# First matching flag will be used
CPU_FEATURES_MAP=(
	cpu_flags_x86_avx512bw:avx512bw
	cpu_flags_x86_avx512f:avx512f
	cpu_flags_x86_avx2:avx2
	cpu_flags_x86_xop:xop
	cpu_flags_x86_avx:avx
	cpu_flags_x86_sse4_2:sse4.2
	cpu_flags_x86_sse4_1:sse4.1
	cpu_flags_x86_ssse3:ssse3
	cpu_flags_x86_sse2:sse2

	cpu_flags_ppc_altivec:altivec

	cpu_flags_arm_neon:neon
)

IUSE="custom-cflags kerberos mpi opencl openmp pcap test ${CPU_FEATURES_MAP[*]%:*}"

DEPEND="
	>=dev-libs/openssl-1.0.1:=
	virtual/libcrypt:=
	mpi? ( virtual/mpi )
	opencl? ( virtual/opencl )
	kerberos? ( virtual/krb5 )
	pcap? ( net-libs/libpcap )
	dev-libs/gmp:=
	virtual/zlib:=
	app-arch/bzip2
"
# Missing (unpackaged):
# - Digest::Haval256
# - Digest::x
# See bug #777369.
RDEPEND="
	${DEPEND}
	dev-perl/Compress-Raw-Lzma
	dev-perl/Digest-MD2
	dev-perl/Digest-SHA3
	dev-perl/Digest-GOST
	!app-crypt/johntheripper
"
RESTRICT="!test? ( test )"

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

get_enable_simd() {
	local i
	for i in "${CPU_FEATURES_MAP[@]}" ; do
		if use "${i%:*}"; then
			echo "--enable-simd=${i#*:}"
			break
		fi
	done
}

src_configure() {
	cd src || die

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
		$(use_enable pcap) \
		$(get_enable_simd)
}

src_compile() {
	# Uses default LD=$(CC) but if the user's set LD, it'll call it
	# bug #729432.
	emake LD="$(tc-getCC)" -C src
}

src_test() {
	pax-mark -mr run/john

	# Replace system (/etc/john) includes with cwd-relative for tests
	# bug #960245.
	mkdir test || die
	cp -r run/*.conf run/rules test || die
	cd test || die
	local file
	for file in *.conf; do
		sed -E 's/^.include <(.+)>$/.include "\1"/g' -i "$file" || die
	done

	if use opencl; then
		# GPU tests fail in portage, so run cpu only tests
		# Reasons: kernels not in /etc/john/opencl (yet) and sandbox
		../run/john --config=john.conf --device=cpu --test=0 --verbosity=2 || die
	else
		# Weak tests
		../run/john --config=john.conf --test=0 --verbosity=2 || die
		# Strong tests
		#../run/john --config=john.conf --test=1 --verbosity=2 || die
	fi
}

src_install() {
	cd run || die

	# Executables
	dosbin john
	newsbin mailer john-mailer

	pax-mark -mr "${ED}/usr/sbin/john"

	local s
	# find . -maxdepth 1 -type l -lname 'john'
	for s in base64conv gpg2john rar2john unafs undrop unique unshadow zip2john
	do
		dosym john /usr/sbin/${s}
	done

	# find . -maxdepth 1 -type f -executable -name '*2john'
	for s in racf2john hccap2john uaf2john putty2john dmg2john wpapcap2john bitlocker2john keepass2john
	do
		dosbin ${s}
	done

	# Scripts
	exeinto /usr/share/john
	doexe ./*.pl ./*.py
	insinto /usr/share/john
	doins -r lib
	doins ./*.lua

	local s
	for s in *.pl *.py; do
		dosym "../share/john/${s}" "/usr/bin/${s}"
	done

	if use opencl; then
		insinto /etc/john
		doins -r opencl
	fi

	# Config files
	insinto /etc/john
	doins ./*.chr password.lst
	doins ./*.conf
	doins -r rules ztex

	# Completions
	newbashcomp john.bash_completion john
	bashcomp_alias john unique
	newzshcomp john.zsh_completion _john

	cd .. || die

	# Documentation
	rm -f doc/README doc/LICENSE || die
	dodoc -r README.md LICENSE doc/*
}
