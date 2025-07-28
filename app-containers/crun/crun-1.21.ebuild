# Copyright 2019-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )

inherit libtool python-any-r1 flag-o-matic

DESCRIPTION="Fast and low-memory footprint OCI Container Runtime fully written in C"
HOMEPAGE="https://github.com/containers/crun"

if [[ "${PV}" == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/containers/${PN}.git"
else
	SRC_URI="https://github.com/containers/${PN}/releases/download/${PV}/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv"
fi

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0"
IUSE="+bpf +caps criu +seccomp selinux systemd static-libs"

DEPEND="
	dev-libs/yajl:=
	sys-kernel/linux-headers
	caps? ( sys-libs/libcap )
	criu? ( >=sys-process/criu-3.15 )
	elibc_musl? ( sys-libs/error-standalone )
	seccomp? ( sys-libs/libseccomp )
	systemd? ( sys-apps/systemd:= )
"
RDEPEND="
	${DEPEND}
	selinux? ( sec-policy/selinux-container )
"
BDEPEND="
	${PYTHON_DEPS}
	virtual/pkgconfig
"

src_prepare() {
	default
	elibtoolize
}

src_configure() {
        if use elibc_musl ; then
                append-cflags "$($(tc-getPKG_CONFIG) --cflags error-standalone)"
                append-libs "$($(tc-getPKG_CONFIG) --libs error-standalone)"
        fi
	local myeconfargs=(
		--cache-file="${S}"/config.cache
		$(use_enable bpf)
		$(use_enable caps)
		$(use_enable criu)
		$(use_enable seccomp)
		$(use_enable systemd)
		--enable-shared
		$(use_enable static-libs static)
	)

	econf "${myeconfargs[@]}"
}

src_test() {
	emake check-TESTS -C ./libocispec

	# The crun test suite is comprehensive to the extent that tests will fail
	# within a sandbox environment, due to the nature of the privileges
	# required to create linux "containers".
	local supported_tests=(
		"tests/tests_libcrun_utils"
		"tests/tests_libcrun_errors"
		"tests/tests_libcrun_intelrdt"
	)
	emake check-TESTS TESTS="${supported_tests[*]}" CFLAGS="${CFLAGS} -std=gnu17"
}

src_install() {
	emake "DESTDIR=${D}" install-exec
	doman crun.1
	einstalldocs

	find "${ED}" -name '*.la' -type f -delete || die
}
