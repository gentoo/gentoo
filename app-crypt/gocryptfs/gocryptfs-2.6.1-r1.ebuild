# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/gocryptfs.asc
inherit go-module verify-sig

DESCRIPTION="Encrypted overlay filesystem written in Go"
HOMEPAGE="
	https://nuetzlich.net/gocryptfs/
	https://github.com/rfjakob/gocryptfs
"
# https://nuetzlich.net/gocryptfs/releases/
SRC_URI="
	https://github.com/rfjakob/gocryptfs/releases/download/v${PV}/${PN}_v${PV}_src-deps.tar.gz
	verify-sig? ( https://github.com/rfjakob/gocryptfs/releases/download/v${PV}/gocryptfs_v${PV}_src-deps.tar.gz.asc )
"
S=${WORKDIR}/${PN}_v${PV}_src-deps

LICENSE="MIT"
# Vendored licenses
LICENSE+=" Apache-2.0 BSD MIT"
SLOT="0"
KEYWORDS="amd64 ~ppc64 ~riscv ~x86"

IUSE="test"

PROPERTIES="test_privileged"
RESTRICT="!test? ( test ) test"

RDEPEND="dev-libs/openssl:="
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	test? ( sys-fs/fuse:0 )
	verify-sig? ( sec-keys/openpgp-keys-gocryptfs )
"

src_unpack() {
	if use verify-sig; then
		verify-sig_verify_detached "${DISTDIR}"/gocryptfs_v${PV}_src-deps.tar.gz{,.asc}
	fi
	go-module_src_unpack
}

src_prepare() {
	default

	# stub all commands that could rebuild gocrypts during tests
	sed -e 's|./build-without-openssl.bash|true|' \
		-e 's|./build.bash|true|' \
		-i "${S}/test.bash" || die

	# Code linting not relevant downstream
	sed -e 's/command -v shellcheck/false/' \
		-e 's/command -v staticcheck/false/' \
		-e 's/\! go tool \| grep vet/false/' \
		-i "${S}/test.bash" || die

	local -A skip_tests=(
		# cli_test.go:450: wrong exit code: want=12, have=20
		["TestMountPasswordIncorrect"]="tests/cli/cli_test.go"
		# cli_test.go:467: want=9, got=20
		["TestMountPasswordEmpty"]="tests/cli/cli_test.go"
		# ctlsock: listen unix /var/tmp/portage/app-crypt/gocryptfs-2.5.4/temp/gocryptfs-test-parent-0/3259013716/TestOrphanedSocket.572617384.sock: bind: invalid argument
		# cli_test.go:1067: mount failed: exit status 20
		["TestEncryptPaths"]="gocryptfs-xray/xray_tests/xray_test.go"
		["TestOrphanedSocket"]="tests/cli/cli_test.go"
		["TestCtlSock"]="tests/defaults/ctlsock_test.go"
		["TestCtlSockDecrypt"]="tests/defaults/ctlsock_test.go"
		["TestCtlSockDecryptCrash"]="tests/defaults/ctlsock_test.go"
		["TestCtlSockPathOps"]="tests/reverse/ctlsock_test.go"
		["TestCtlSockCrash"]="tests/reverse/ctlsock_test.go"
		["TestSymlinkDentrySize"]="tests/reverse/correctness_test.go"
		["TestExcludeTestFs"]="tests/reverse/exclude_test.go"
		["TestExcludeAllOnlyDir1"]="tests/reverse/exclude_test.go"
		# correctness_test.go:142: should NOT be executable
		["TestAccessVirtualDirIV"]="tests/reverse/correctness_test.go"
		# issue893_test.go:54: mkdir /var/tmp/portage/app-crypt/gocryptfs-2.5.4/temp: permission denied
		["TestConcurrentUserOps"]="tests/root_test/issue893_test.go"
		# root_test.go:86: mkdir ${T}/gocryptfs-test-parent-0/932700816/default-plain/dir1/dir2: permission denied
		# root_test.go:97: open ${T}/gocryptfs-test-parent-0/932700816/default-plain/dir1/file1: permission denied
		["TestSupplementaryGroups"]="tests/root_test/root_test.go"
		# root_test.go:158: mount: ${T}/gocryptfs-test-parent-0/932700816/TestDiskFull.ext4.mnt:
		# failed to setup loop device for ${T}/gocryptfs-test-parent-0/932700816/TestDiskFull.ext4.
		["TestDiskFull"]="tests/root_test/root_test.go"
		# root_test.go:281: O_RDONLY should have worked, but got error: permission denied
		["TestAcl"]="tests/root_test/root_test.go"
		# root_test.go:340: mount: ${T}/gocryptfs-test-parent-0/932700816/TestBtrfsQuirks.img.mnt:
		# failed to setup loop device for ${T}/gocryptfs-test-parent-0/932700816/TestBtrfsQuirks.img.
		["TestBtrfsQuirks"]="tests/root_test/btrfs_test.go"
		# requires root
		["TestRootForceOwner"]="tests/root_test/root_test.go"
	)

	for test in "${!skip_tests[@]}"; do
		sed -e "/^func ${test}(/ a	t.Skip(\"Skipped by Gentoo\")" -i ${skip_tests[$test]} || die
	done
}

src_compile() {
	# call directly to avoid pandoc dependency. The man pages are included in the upstream tarballs
	# https://github.com/rfjakob/gocryptfs/commit/61940a9c0666eba8be21de4f1cd182912f74f929
	./build.bash || die
}

src_test() {
	./test.bash -v || die
}

src_install() {
	emake "DESTDIR=${ED}" install
	dobin contrib/statfs/statfs
	doman Documentation/*.1
	dodoc -r README.md Documentation
	rm -f "${ED}"/usr/share/doc/${PF}/Documentation/{.gitignore,gocryptfs.1,gocryptfs-xray.1,statfs.1,MANPAGE-render.bash} || die
}
