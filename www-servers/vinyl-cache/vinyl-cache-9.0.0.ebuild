# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )

inherit autotools systemd python-r1

DESCRIPTION="A high-performance caching HTTP reverse proxy"
HOMEPAGE="https://vinyl-cache.org/"
SRC_URI="https://vinyl-cache.org/downloads/${P}.tgz"

LICENSE="BSD-2 GPL-2"
SLOT="0/9"
KEYWORDS="amd64 ~arm arm64 ~ppc ~ppc64 ~riscv x86"
IUSE="jit selinux static-libs unwind"

COMMON_DEPEND="
	sys-libs/readline:=
	dev-libs/libedit
	dev-libs/libpcre2[jit?]
	sys-libs/ncurses:=
	unwind? ( sys-libs/libunwind:= )
"

# varnish compiles stuff at run time
RDEPEND="
	${PYTHON_DEPS}
	${COMMON_DEPEND}
	acct-user/vinyl
	acct-group/vinyl
	sys-devel/gcc
	selinux? ( sec-policy/selinux-varnishd )
"
DEPEND="
	${COMMON_DEPEND}
	dev-python/docutils
	dev-python/sphinx
	virtual/pkgconfig
"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# Upstream acknowledge that a small number of tests fail sporadically, including on their
# test boxes. We SKIP problematic tests here.  Check https://vinyl-cache.org/vtest/
SKIP_TESTS=(
	"u00021.vtc" # Commit: 83d9fbb2961c
	"r02686.vtc" # Bug: 880627
	"r02990.vtc" # Bug: 880627
	"u00008.vtc" # Bug: 880627
	"u00009.vtc" # Bug: 880627
	"t02014.vtc" # Bug: 964041
)

src_prepare() {
	default

	# Fix python shebangs for python-exec[-native-symlinks], #909330
	# skip vmodtool, as that gets installed by python_replicate_script later
	local shebangs=($(grep -rl "#!/usr/bin/env python3"|grep -v vmodtool || die))
	python_setup
	python_fix_shebang -q ${shebangs[*]}

	# SKIP unreliable tests
	local t
	for t in ${SKIP_TESTS[*]}; do
		sed -i -e '/^vtest.*$/a feature cmd false' bin/vinyltest/tests/${t} || die
	done

	# Remove -Werror bug #528354
	sed -i -e 's/-Werror\([^=]\)/\1/g' configure.ac || die

	# Upstream doesn't put vinyl.m4 in the m4/ directory
	# We link because the Makefiles look for the file in
	# the original location
	ln -sf ../vinyl.m4 m4/vinyl.m4 || die

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--with-contrib
		$(use_enable static-libs static)
		$(use_enable jit pcre2-jit)
		$(use_with unwind)
		--without-jemalloc
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	emake DESTDIR="${D}" install

	python_replicate_script "${D}/usr/share/vinyl-cache/vmodtool.py"

	newinitd "${FILESDIR}"/vinyllog.initd vinyllog
	newconfd "${FILESDIR}"/vinyllog.confd vinyllog

	newinitd "${FILESDIR}"/vinylncsa.initd vinylncsa
	newconfd "${FILESDIR}"/vinylncsa.confd vinylncsa

	newinitd "${FILESDIR}"/vinyld.initd vinyld
	newconfd "${FILESDIR}"/vinyld.confd vinyld

	insinto /etc/logrotate.d/
	newins "${FILESDIR}/vinyld.logrotate" vinyld

	diropts -m750

	keepdir /var/lib/vinyl-cache
	keepdir /var/log/vinyl-cache

	systemd_dounit "${FILESDIR}/vinyld.service"

	insinto /etc/vinyl-cache/
	doins vmod/vmod_*.vcc
	doins etc/example.vcl

	dodoc README.md
	dodoc doc/changes.rst

	fowners root:vinyl /etc/vinyl-cache/
	fowners vinyl:vinyl /var/lib/vinyl-cache/
	fperms 0750 /var/lib/vinyl-cache/ /etc/vinyl-cache/

	find "${ED}" -name "*.la" -delete || die
}
