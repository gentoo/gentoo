# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="rsync-like utility for btrfs snapshots"
HOMEPAGE="https://github.com/AmesCornish/buttersink"

LICENSE="GPL-3"
SLOT=0

# local tests would require root and cause sandbox issues with btrfs subvolume
# operations, and network tests would require an SSH server with root login to
# test the SSH backend, or remote S3 for that backend
RESTRICT="test"

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	KEYWORDS=""
	EGIT_REPO_URI="https://github.com/AmesCornish/buttersink"
	SRC_URI=""
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/AmesCornish/buttersink/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

RDEPEND="${PYTHON_DEPS}
	dev-python/boto[${PYTHON_USEDEP}]
	dev-python/crcmod[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	sys-fs/btrfs-progs"
DEPEND="${RDEPEND}"

python_prepare_all() {
	if [[ ${PV} == 9999 ]] ; then
		emake makestamps buttersink/version.py
	else
		mkdir makestamps || die
		echo "version = \"${PV}\"" > buttersink/version.py || die
	fi
	distutils-r1_python_prepare_all
}
