# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="rsync-like utility for btrfs snapshots"
HOMEPAGE="https://github.com/AmesCornish/buttersink"

LICENSE="GPL-3"
SLOT=0

# tests require network access
RESTRICT="test"

if [[ "${PV}" == 9999 ]] ; then
	inherit git-r3
	KEYWORDS=""
	EGIT_REPO_URI="https://github.com/AmesCornish/buttersink"
	SRC_URI=""
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/AmesCornish/buttersink/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

RDEPEND="${PYTHON_DEPS}
	dev-python/boto
	dev-python/crcmod
	dev-python/flake8
	dev-python/psutil
	sys-fs/btrfs-progs"
DEPEND="${RDEPEND}"

python_prepare()
{
	if [[ ${PV} == 9999 ]] ; then
		emake makestamps
		emake buttersink/version.py
	else
		mkdir makestamps
		echo "version = \"${PV}\"" > buttersink/version.py
	fi
}
