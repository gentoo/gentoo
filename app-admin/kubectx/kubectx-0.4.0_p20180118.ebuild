# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit vcs-snapshot bash-completion-r1

COMMIT="b2992aa0df9143c25d64843b3ee40fbcd7332f07"

DESCRIPTION="Fast way to switch between clusters and namespaces in kubectl"
HOMEPAGE="https://github.com/ahmetb/kubectx"
SRC_URI="https://github.com/ahmetb/kubectx/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="sys-cluster/kubectl"

src_install() {
	insinto /usr/include
	doins utils.bash
	dobin kubectx kubens

	insinto /usr/share/zsh/site-functions
	newins completion/kubectx.zsh _kubectx
	newins completion/kubens.zsh _kubens

	newbashcomp completion/kubectx.bash kubectx
	newbashcomp completion/kubens.bash kubens
}
