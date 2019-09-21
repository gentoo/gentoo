# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit vcs-snapshot bash-completion-r1

DESCRIPTION="Fast way to switch between clusters and namespaces in kubectl"
HOMEPAGE="https://github.com/ahmetb/kubectx"
SRC_URI="https://github.com/ahmetb/kubectx/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="sys-cluster/kubectl"

src_install() {
	dobin kubectx kubens

	insinto /usr/share/zsh/site-functions
	newins completion/kubectx.zsh _kubectx
	newins completion/kubens.zsh _kubens

	newbashcomp completion/kubectx.bash kubectx
	newbashcomp completion/kubens.bash kubens
}
