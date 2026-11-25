# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	'0B4235A1DE4EB7BB978E070CA072D4D04358C584:xmlgraphics02:manual,ubuntu'
	'39DF200ECF6DCF076D968A2773CE2EFB8408F755:manual'
	'5C9A30FF22B2C02F30261C305B93F1DF7CDB6DEA:xmlgraphics:manual'
	'700A735AB4EC4B56F9112852F73095707C611584:xmlgraphics03:manual,ubuntu'
	'7FFB2D270C4DE3113518D09DE3E4404FCC31AE97:xmlgraphics04:manual,ubuntu'
	'AB6638CE472A499B3959ADA2F989A2E5C93C5700:manual'
	'BE316D878F7CF48341EF13563E2A6FC25F298824:xmlgraphics05:manual,ubuntu'
	'D3544AC1BCADDF9D424FD0256654BABE0ED3D317:xmlgraphics06:manual,ubuntu'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by xmlgraphics.apache.org/commons"
HOMEPAGE="https://xmlgraphics.apache.org/commons/download.html"
SRC_URI+=" https://downloads.apache.org/xmlgraphics/fop/KEYS -> ${P}"
KEYWORDS="amd64 arm64 ppc64"
