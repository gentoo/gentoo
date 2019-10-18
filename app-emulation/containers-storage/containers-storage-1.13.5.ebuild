# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGO_VENDOR=(
	"github.com/pquerna/ffjson e517b90714f7c0eabe6d2e570a5886ae077d6db6"
)

inherit golang-vcs-snapshot

KEYWORDS="~amd64"
DESCRIPTION="containers/storage library"
HOMEPAGE="https://github.com/containers/storage"
LICENSE="Apache-2.0 BSD BSD-2 CC-BY-SA-4.0 ISC MIT"
SLOT="0"
IUSE="btrfs +device-mapper test"
EGO_PN="${HOMEPAGE#*//}"
EGIT_COMMIT="v${PV}"
SRC_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"
RDEPEND="
	btrfs? ( sys-fs/btrfs-progs )
	device-mapper? ( sys-fs/lvm2:= )"
DEPEND="${RDEPEND}
	dev-go/go-md2man
	test? (
		sys-fs/btrfs-progs
		sys-fs/lvm2
		sys-apps/util-linux
	)"
RESTRICT="test? ( userpriv ) !test? ( test )"

src_unpack() {
	golang-vcs-snapshot_src_unpack
}

src_prepare() {
	default

	[[ -f ${S}/src/${EGO_PN}/hack/btrfs_tag.sh ]] || die
	use btrfs || { echo -e "#!/bin/sh\necho exclude_graphdriver_btrfs" > \
		"${S}/src/${EGO_PN}/hack/btrfs_tag.sh" || die; }

	[[ -f ${S}/src/${EGO_PN}/hack/libdm_tag.sh ]] || die
	use device-mapper || { echo -e "#!/bin/sh\necho btrfs_noversion exclude_graphdriver_devicemapper" > \
		"${S}/src/${EGO_PN}/hack/libdm_tag.sh" || die; }

	sed -e 's:TestChrootUntarPath(:_\0:' \
		-i "${S}/src/${EGO_PN}/pkg/chrootarchive/archive_test.go" || die
	sed -e 's:TestTarUntar(:_\0:' \
		-e 's:TestTarWithOptionsChownOptsAlwaysOverridesIdPair(:_\0:' \
		-e 's:TestTarWithOptions(:_\0:' \
		-i "${S}/src/${EGO_PN}/pkg/archive/archive_test.go" || die
	sed -e 's:TestTarUntarWithXattr(:_\0:' \
		-e 's:TestTarWithBlockCharFifo(:_\0:' \
		-i "${S}/src/${EGO_PN}/pkg/archive/archive_unix_test.go" || die
	sed -e 's:TestTarUntarWithXattr(:_\0:' \
		-i "${S}/src/${EGO_PN}/pkg/archive/archive_test.go" || die
	sed -e 's:TestApplyLayer(:_\0:' \
		-i "${S}/src/${EGO_PN}/pkg/archive/changes_test.go" || die
	sed -e 's:TestApplyLayerInvalidFilenames(:_\0:' \
		-e 's:TestApplyLayerInvalidHardlink(:_\0:' \
		-e 's:TestApplyLayerInvalidSymlink(:_\0:' \
		-e 's:TestApplyLayerWhiteouts(:_\0:' \
		-i "${S}/src/${EGO_PN}/pkg/archive/diff_test.go" || die
	sed -e 's:TestCopyCaseE(:_\0:' \
		-e 's:TestCopyCaseEFSym(:_\0:' \
		-e 's:TestCopyCaseG(:_\0:' \
		-e 's:TestCopyCaseGFSym(:_\0:' \
		-e 's:TestCopyCaseH(:_\0:' \
		-e 's:TestCopyCaseHFSym(:_\0:' \
		-e 's:TestCopyCaseJ(:_\0:' \
		-e 's:TestCopyCaseJFSym(:_\0:' \
		-i "${S}/src/${EGO_PN}/pkg/archive/copy_unix_test.go" || die
	sed -e 's:TestMount(:_\0:' \
		-i "${S}/src/${EGO_PN}/pkg/mount/mounter_linux_test.go" || die
}

src_compile() {
	export -n GOCACHE XDG_CACHE_HOME #678856
	mkdir -p "${S}/src/github.com/pquerna" || die
	ln -s "${S}/src/${EGO_PN}/vendor/github.com/pquerna/ffjson" "${WORKDIR}/${P}/src/github.com/pquerna/ffjson" || die
	mkdir -p "${S}/bin" || die
	cd "${S}/bin" || die
	GOPATH="${S}" GOBIN="${S}/bin" \
		go build -v -work -x ${EGO_BUILD_FLAGS} "${S}/src/github.com/pquerna/ffjson/ffjson.go" || die
	GOPATH="${S}" GOBIN="${S}/bin" PATH="${S}/bin:${PATH}" \
		emake -C "${S}/src/${EGO_PN}" containers-storage docs
}

src_install() {
	dobin "${S}/src/${EGO_PN}/${PN}"
	while read -r -d ''; do
		mv "${REPLY}" "${REPLY%.1}" || die
	done < <(find "${S}/src/${EGO_PN}/docs" -name '*.[[:digit:]].1' -print0)
	find "${S}/src/${EGO_PN}/docs" -name '*.[[:digit:]]' -exec doman '{}' + || die
}

src_test() {
	GOPATH="${S}" unshare -m emake -C "${S}/src/${EGO_PN}" FLAGS="-v -work -x" local-test-unit || die
}
