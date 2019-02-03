# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGIT_COMMIT="9551f6bb379d4af56dfb63ddf0f3682e40a6694e"
EGO_PN="github.com/containers/${PN}"

inherit golang-vcs-snapshot systemd

DESCRIPTION="Library and podman tool for running OCI-based containers in Pods"
HOMEPAGE="https://github.com/containers/libpod/"
SRC_URI="https://github.com/containers/libpod/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"

KEYWORDS="~amd64"
IUSE="apparmor btrfs ostree selinux"
REQUIRED_USE="!selinux? ( !ostree )"
RESTRICT="test"

COMMON_DEPEND="
	app-crypt/gpgme:=
	>=app-emulation/cri-o-1.13.0
	app-emulation/runc
	dev-libs/libassuan:=
	dev-libs/libgpg-error:=
	sys-fs/lvm2
	sys-libs/libseccomp:=

	apparmor? ( sys-libs/libapparmor )
	btrfs? ( sys-fs/btrfs-progs )
	ostree? (
		dev-libs/glib:=
		dev-util/ostree:=
	)
	selinux? ( sys-libs/libselinux:= )
"
DEPEND="
	${COMMON_DEPEND}
	dev-go/go-md2man"
RDEPEND="${COMMON_DEPEND}"
S="${WORKDIR}/${P}/src/${EGO_PN}"

src_prepare() {
	default

	# Disable installation of python modules here, since those are
	# installed by separate ebuilds.
	sed -e '/^GIT_.*/d' \
		-e 's/$(GO) build/$(GO) build -v -work -x/' \
		-e 's/^\(install:.*\) install\.python$/\1/' \
		-i Makefile || die
}

src_compile() {
	[[ -f hack/apparmor_tag.sh ]] || die
	if use apparmor; then
		echo -e "#!/bin/sh\necho apparmor" > hack/apparmor_tag.sh || die
	else
		echo -e "#!/bin/sh\ntrue" > hack/apparmor_tag.sh || die
	fi

	[[ -f hack/btrfs_installed_tag.sh ]] || die
	if use btrfs; then
		echo -e "#!/bin/sh\ntrue" > hack/btrfs_installed_tag.sh || die
	else
		echo -e "#!/bin/sh\necho exclude_graphdriver_btrfs" > \
			hack/btrfs_installed_tag.sh || die
	fi

	[[ -f hack/ostree_tag.sh ]] || die
	if use ostree; then
		echo -e "#!/bin/sh\necho ostree" > hack/ostree_tag.sh || die
	else
		echo -e "#!/bin/sh\necho containers_image_ostree_stub" > hack/ostree_tag.sh || die
	fi

	[[ -f hack/selinux_tag.sh ]] || die
	if use selinux; then
		echo -e "#!/bin/sh\necho selinux" > hack/selinux_tag.sh || die
	else
		echo -e "#!/bin/sh\ntrue" > hack/selinux_tag.sh || die
	fi

	env -u LDFLAGS GOPATH="${WORKDIR}/${P}" GOBIN="${WORKDIR}/${P}/bin" \
		emake all \
			GIT_BRANCH=master \
			GIT_BRANCH_CLEAN=master \
			COMMIT_NO="${EGIT_COMMIT}" \
			GIT_COMMIT="${EGIT_COMMIT}"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${D}${EPREFIX}/usr" install

	insinto /etc/containers
	newins test/registries.conf registries.conf.example

	newinitd "${FILESDIR}"/podman.initd podman

	insinto /etc/logrotate.d
	newins "${FILESDIR}/podman.logrotated" podman

	keepdir /var/lib/containers
}
