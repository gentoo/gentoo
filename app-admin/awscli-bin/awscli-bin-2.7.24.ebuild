# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="command line interface for Amazon Web Services"
HOMEPAGE="
	https://aws.amazon.com/cli/
	https://github.com/aws/aws-cli/
	"
SRC_URI="
	amd64? ( https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${PV}.zip )
	arm64? ( https://awscli.amazonaws.com/awscli-exe-linux-aarch64-${PV}.zip )
	"

LICENSE="
	Apache-2.0 MIT LGPL-2.1+ BSD GPL-2+-with-Pyinstaller-Bootloader-exception
	openssl PSF-2 BSD-2 GPL-3+ public-domain
	"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm64"

RDEPEND="!app-admin/awscli
	sys-libs/glibc"
BDEPEND="app-arch/unzip"

QA_PREBUILT="*"
RESTRICT="strip"
S="${WORKDIR}"

# This code is based on the install script in the upstream archive.

set_global_vars() {
	ROOT_INSTALL_DIR=/opt/aws-cli
	BIN_DIR=/usr/bin

	EXE_NAME="aws"
	COMPLETER_EXE_NAME="aws_completer"
	INSTALLER_DIR="aws"
	INSTALLER_DIST_DIR="${INSTALLER_DIR}/dist"
	INSTALLER_EXE="${INSTALLER_DIST_DIR}/${EXE_NAME}"
	AWS_EXE_VERSION=${PV}

	INSTALL_DIR="${ROOT_INSTALL_DIR}/v2/${AWS_EXE_VERSION}"
	# INSTALL_DIR="${INSTALL_DIR}"
	INSTALL_DIST_DIR="${INSTALL_DIR}/dist"
	INSTALL_BIN_DIR="${INSTALL_DIR}/bin"
	INSTALL_AWS_EXE="${INSTALL_BIN_DIR}/${EXE_NAME}"
	INSTALL_AWS_COMPLETER_EXE="${INSTALL_BIN_DIR}/${COMPLETER_EXE_NAME}"

	CURRENT_INSTALL_DIR="${ROOT_INSTALL_DIR}/v2/current"
	CURRENT_AWS_EXE="${CURRENT_INSTALL_DIR}/bin/${EXE_NAME}"
	CURRENT_AWS_COMPLETER_EXE="${CURRENT_INSTALL_DIR}/bin/${COMPLETER_EXE_NAME}"

	BIN_AWS_EXE="${BIN_DIR}/${EXE_NAME}"
	BIN_AWS_COMPLETER_EXE="${BIN_DIR}/${COMPLETER_EXE_NAME}"
}

create_install_dir() {
	dodir "${INSTALL_DIR}"
	setup_install_dist
	setup_install_bin
	create_current_symlink
}

setup_install_dist() {
	cp -r "${INSTALLER_DIST_DIR}" "${D}/${INSTALL_DIST_DIR}" || die
}

setup_install_bin() {
	dodir "${INSTALL_BIN_DIR}"
	dosym "../dist/${EXE_NAME}" "${INSTALL_AWS_EXE}"
	dosym "../dist/${COMPLETER_EXE_NAME}" "${INSTALL_AWS_COMPLETER_EXE}"
}

create_current_symlink() {
	dosym "${AWS_EXE_VERSION}" "${CURRENT_INSTALL_DIR}"
}

create_bin_symlinks() {
	dodir "${BIN_DIR}"
	dosym -r "${CURRENT_AWS_EXE}" "${BIN_AWS_EXE}"
	dosym -r "${CURRENT_AWS_COMPLETER_EXE}" "${BIN_AWS_COMPLETER_EXE}"
}

src_install() {
	set_global_vars
	create_install_dir
	create_bin_symlinks
}
