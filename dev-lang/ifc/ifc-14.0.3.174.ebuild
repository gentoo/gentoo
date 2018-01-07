# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

INTEL_DPN=parallel_studio_xe
INTEL_DID=4220
INTEL_DPV=2013_sp1_update3
INTEL_SUBDIR=composerxe
INTEL_SINGLE_ARCH=false

inherit intel-sdp

DESCRIPTION="Intel FORTRAN Compiler"
HOMEPAGE="http://software.intel.com/en-us/articles/intel-composer-xe/"

IUSE="l10n_ja"
KEYWORDS="-* ~amd64 ~x86 ~amd64-linux ~x86-linux"

# avoid file collision with icc #476330
RDEPEND="l10n_ja? ( !dev-lang/icc[l10n_ja(-)] !dev-lang/icc[linguas_ja(-)] )
	~dev-libs/intel-common-${PV}[compiler,multilib=]"

INTEL_BIN_RPMS="compilerprof compilerprof-devel"
INTEL_DAT_RPMS="compilerprof-common"

CHECKREQS_DISK_BUILD=375M

src_install() {
	if ! use l10n_ja; then
		find "${S}" -type d -name ja_JP -exec rm -rf '{}' + || die
	fi
	intel-sdp_src_install
}
