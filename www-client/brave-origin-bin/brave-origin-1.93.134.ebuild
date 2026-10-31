# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop unpacker xdg

DESCRIPTION="Minimalist Brave browser (no Rewards, Wallet, VPN or Leo AI), binary release"
HOMEPAGE="https://brave.com/origin/"
SRC_URI="https://brave-browser-apt-release.s3.brave.com/pool/main/b/brave-origin/brave-origin_${PV}_amd64.deb"
S="${WORKDIR}"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="-* ~amd64"
RESTRICT="bindist mirror strip test"

RDEPEND="
	>=app-accessibility/at-spi2-core-2.46.0:2
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	media-libs/alsa-lib
	media-libs/mesa[gbm(+)]
	net-print/cups
	sys-apps/dbus
	sys-apps/util-linux
	x11-libs/cairo
	x11-libs/libdrm
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libxkbcommon
	x11-libs/libXrandr
	x11-libs/pango
	x11-misc/xdg-utils
"

QA_PREBUILT="opt/brave.com/brave-origin/*"

src_unpack() {
	unpack_deb ${A}
}

src_install() {
	local dest="/opt/brave.com/brave-origin"

	# cp -a keeps the exec bits that doins would strip
	dodir /opt/brave.com
	cp -a opt/brave.com/brave-origin "${ED}/opt/brave.com/" || die
	[[ -x "${ED}${dest}"/brave-origin ]] || die "launcher not found, check .deb layout"
	[[ -f "${ED}${dest}"/chrome-sandbox ]] && fperms 4711 "${dest}"/chrome-sandbox

	dosym "${dest}"/brave-origin /usr/bin/brave-origin
	dosym "${dest}"/brave-origin /usr/bin/brave-origin-stable

	domenu usr/share/applications/brave-origin.desktop

	local size
	for size in 16 24 32 48 64 128 256; do
		if [[ -f opt/brave.com/brave-origin/product_logo_${size}.png ]]; then
			newicon -s ${size} opt/brave.com/brave-origin/product_logo_${size}.png brave-origin.png
		fi
	done
}
