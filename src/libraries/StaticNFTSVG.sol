// SPDX-License-Identifier: MIT
import "./LibString.sol";
import "../dependencies/openzeppelin/Base64.sol";
import "./QRSVG.sol";

pragma solidity 0.8.14;

library StaticNFTSVG {
    string internal constant BASE_URL = "https://link3.to/";

    function draw(string memory handle) internal pure returns (string memory) {
        uint16 handleBackgroundWidth = 0;
        string memory handleSVGElement = "";
        string memory handleInLink = handle;
        string memory qrCode = QRSVG.generateQRCode(
            string(abi.encodePacked(BASE_URL, handle))
        );

        if (bytes(handle).length > 13) {
            string memory headString = substring(handle, 0, 12);

            handleSVGElement = string(
                abi.encodePacked(
                    getHandleSVGtext(headString, 0),
                    getHandleSVGtext(
                        substring(handle, 13, bytes(handle).length),
                        90
                    )
                )
            );
            handleInLink = string(abi.encodePacked(headString, ".."));
            handleBackgroundWidth = 188;
        } else {
            handleSVGElement = getHandleSVGtext(handle, 0);
            handleBackgroundWidth = uint16(bytes(handle).length - 1) * 13 + 30;
        }

        string memory fontStyleSVGElement = getFontStyleSVGElement();
        string memory backgroundPath = getBackgroundPath();
        string memory qrCodeSVGElement = getQRCodeSVGElement(qrCode);
        string memory linkSVGElement = getLinkSVGElement(
            handleBackgroundWidth,
            handleInLink
        );

        string memory svg = compose(
            fontStyleSVGElement,
            handleSVGElement,
            backgroundPath,
            qrCodeSVGElement,
            linkSVGElement
        );

        string memory uri = string(
            abi.encodePacked(
                "data:image/svg+xml;base64,",
                Base64.encode(abi.encodePacked(svg))
            )
        );

        return uri;
    }

    function substring(
        string memory str,
        uint256 startIndex,
        uint256 endIndex
    ) internal pure returns (string memory) {
        bytes memory strBytes = bytes(str);
        bytes memory result = new bytes(endIndex - startIndex);
        for (uint256 i = startIndex; i < endIndex; i++) {
            result[i - startIndex] = strBytes[i];
        }
        return string(result);
    }

    function getFontStyleSVGElement() internal pure returns (string memory) {
        return
            "<style>@font-face {font-family='\"Outfit\", sans-serif;'}</style>";
    }

    function getBackgroundPath() internal pure returns (string memory) {
        return
            "<path d='M59 104.826C59 92.0806 62.0452 79.5197 67.882 68.1894L84.3299 36.2613C89.4741 26.2754 99.766 20 110.999 20H177.569H421.276C432.322 20 441.276 28.9543 441.276 40V428.566C441.276 437.981 436.856 446.85 429.339 452.519L406.262 469.921C397.588 476.462 387.02 480 376.157 480H182.724H79C67.9543 480 59 471.046 59 460V104.826Z' fill='black'/>";
    }

    function getQRCodeSVGElement(string memory base64String)
        internal
        pure
        returns (string memory)
    {
        return
            string(
                abi.encodePacked(
                    "<image x='20.69%' y='42.72%' href='",
                    base64String,
                    "' width='32.305%' height='32.305%' opacity='0.3'/>"
                )
            );
    }

    function getLinkSVGElement(uint16 backgroundWidth, string memory handle)
        internal
        pure
        returns (string memory)
    {
        return
            string(
                abi.encodePacked(
                    "<g style='transform:translate(19.626%, 83.8%)'>",
                    "<text dominant-baseline='hanging' x='0' y='0' fill='#fff' font-size='22px' font-weight='700' font-family='\"Outfit\", sans-serif'>link3.to/</text>",
                    "<rect width='",
                    LibString.toString(backgroundWidth),
                    "px' height='24px' rx='4px' ry='4px' fill='#fff' transform='skewX(-25)' x='95' y='-3'/>",
                    "<text dominant-baseline='hanging' text-anchor='start' x='100' y='-1' font-weight='400' font-family='\"Outfit\", sans-serif' font-size='22px' fill='#000'>",
                    handle,
                    "</text></g>"
                )
            );
    }

    function compose(
        string memory fontStyleSVGElement,
        string memory handleSVGElement,
        string memory backgroundPath,
        string memory qrCodeSVGElement,
        string memory linkSVGElement
    ) internal pure returns (string memory) {
        return
            string(
                abi.encodePacked(
                    "<svg width='500' height='500' viewBox='0 0 500 500' fill='none' xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink'>",
                    fontStyleSVGElement,
                    backgroundPath,
                    handleSVGElement,
                    qrCodeSVGElement,
                    linkSVGElement,
                    "</svg>"
                )
            );
    }

    function getHandleSVGtext(string memory handle, uint16 yValue)
        internal
        pure
        returns (string memory)
    {
        uint16 y = yValue > 0 ? yValue : 50;

        return
            string(
                abi.encodePacked(
                    "<text text-anchor='end' dominant-baseline='hanging' x='412' y='",
                    LibString.toString(y),
                    "' fill='#fff' font-weight='700' font-family='\"Outfit\", sans-serif' font-size='32'>",
                    handle,
                    "</text>"
                )
            );
    }
}
