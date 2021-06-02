# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=DPATES
inherit perl-module

DESCRIPTION="Fuse module for perl"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="amd64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	sys-fs/fuse:0=
	dev-perl/Filesys-Statvfs
	dev-perl/Lchown
	dev-perl/Unix-Mknod
"
DEPEND="
	sys-fs/fuse:0=
"
BDEPEND="
	virtual/perl-ExtUtils-MakeMaker
	test? (
		${RDEPEND}
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-0.16.1-no-dot-inc-tests.patch"
	"${FILESDIR}/${PN}-0.16.1-tempdir-override.patch"
	"${FILESDIR}/${PN}-0.16.1-ioctl-header.patch"
)
PERL_RM_FILES=(
	test/pod.t
)

src_compile() {
	mymake=(
		"OPTIMIZE=${CFLAGS}"
	)
	perl-module_src_compile
}

src_test() {
	if has usersandbox ${FEATURES}; then
		ewarn "'FEATURES=usersandbox' detected, skipping tests"
		return
	fi
	export FUSE_TEMPDIR="${T}/fuse"
	mkdir -p "${FUSE_TEMPDIR}" || die "Can't mkdir ${FUSE_TEMPDIR}"
	export FUSE_MOUNTPOINT="${FUSE_TEMPDIR}/fuse-mount"
	export FUSE_TESTMOUNT="${FUSE_TEMPDIR}/fuse-test"
	export FUSE_PIDFILE="${FUSE_TEMPDIR}/mounted.pid"
	export FUSE_LOGFILE="${FUSE_TEMPDIR}/fusemnt.log"
	# Strict ordering required
	export DIST_TEST="do verbose"
	perl-module_src_test
}
