// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library JsSource {
    string public constant JS_SOURCE =
        "const organizationId = args[0];"
        "const eventId = args[1];"
        "const msgSender = args[2];"
        "const percentOff = args[3];"
        "const quantityAvailable = args[4];"
        "const resolveAddressToLensHandle = await Functions.makeHttpRequest({"
        "    url: `https://api.lens.dev`,"
        "    method: `POST`,"
        "    headers: {"
        "        'Content-Type': 'application/json'"
        "    },"
        "    data: {"
        "        query: `{"
        "            profiles(request: { ownedBy: [`${msgSender}`] }) {"
        "                items {"
        "                    name"
        "                }"
        "            }"
        "        }`,"
        "    }"
        "})"
        "const lensHandle = resolveAddressToLensHandle.data.data.profiles.items[0].name;"
        "console.log(lensHandle);"
        "const discountCode = `DISCOUNT_CODE_${organizationId}_${eventId}_${lensHandle}`;"
        "const createDiscount = await Functions.makeHttpRequest({"
        "    url: `https://www.eventbriteapi.com/v3/organizations/${organizationId}/discounts/`,"
        "    method: `POST`,"
        "    headers: {"
        "        'Authorization': `Bearer ${secrets.OATH_KEY}`,"
        "        'Content-Type': 'application/json'"
        "    },"
        "    data: {"
        "        `discount`: {"
        "            `type`: `coded`,"
        "            `code`: discountCode,"
        "            `percent_off`: percentOff,"
        "            `event_id`: eventId,"
        "            `quantity_available`: quantityAvailable"
        "        }"
        "    }"
        "});"
        "if (createDiscount.status == 200) {"
        "    console.log(createDiscount.data.code);"
        "} else {"
        "    console.error(createDiscount.message);"
        "}"
        "const getEventUrl = await Functions.makeHttpRequest({"
        "  url: `https://www.eventbriteapi.com/v3/events/${eventId}/`,"
        "  method: `GET`,"
        "  headers: {"
        "    'Authorization': `Bearer ${secrets.OAUTH_KEY}`,"
        "    'Content-Type': 'application/json',"
        "  }"
        "});"
        "if (getEventUrl.status == 200) {"
        "  console.log(`Event URL: `, getEventUrl.data.url);"
        "} else {"
        "  console.error(`Error fetching Event: ` + getEventUrl);"
        "}"
        "const urlWithDiscount = `${getEventUrl.data.url}?discount= ${discountCode}`"
        "console.log(`URL with discount: `, urlWithDiscount)"
        "return Functions.encodeString(urlWithDiscount);";
}
