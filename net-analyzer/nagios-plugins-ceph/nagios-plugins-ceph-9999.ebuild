# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..9} )

inherit python-single-r1

DESCRIPTION="Nagios plugins for Ceph"
HOMEPAGE="https://github.com/ceph/ceph-nagios-plugins"

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ceph/ceph-nagios-plugins"
else
	# Upstream lags Github releases, so download a tarball of the specific commit
	SNAPSHOT_COMMIT="10393f64afd3a73ccb0cc96e4ada20d9cca92897"
	SRC_URI="https://github.com/ceph/ceph-nagios-plugins/archive/${SNAPSHOT_COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/ceph-nagios-plugins-${SNAPSHOT_COMMIT}"
	KEYWORDS="~amd64"
fi

LICENSE="Apache-2.0"
SLOT="0"

DEPEND=""
RDEPEND="
	${DEPEND}
	${PYTHON_DEPS}
	acct-group/nagios
	acct-user/nagios
	sys-cluster/ceph
"
BDEPEND=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_prepare() {
	default
	python_fix_shebang "${S}"/src/*
}

src_install() {
	emake DESTDIR="${D}" install sysconfdir=/etc libdir=/usr/$(get_libdir)
}
