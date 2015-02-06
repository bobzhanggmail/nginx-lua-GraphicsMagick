local area = nil

local originalUri = ngx.var.uri;

local originalFile = ngx.var.file;

local index = string.find(ngx.var.uri, "([0-9]+)x([0-9]+)");

local ext='.'..originalUri:match(".+%.(%w+)$");

if index then

    originalUri = string.sub(ngx.var.uri, 0, index-2);

    area = string.sub(ngx.var.uri, index);

    index1 = string.find(area, "([.])");

    area1 = string.sub(area, 0, index1-1);

    local index2 = string.find(originalFile, "([0-9]+)x([0-9]+)");
    
    originalFile1 = string.sub(originalFile, 0, index2-2);

    local index3=string.find(originalFile1,ext);
    -- 支持类似aa_80x80.jpg的格式
    if index3==nil then 
        originalFile1 = string.sub(originalFile, 0, index2-2)..ext;
        originalUri = originalUri..ext;
    end
end

local image_sizes = {"80x80", "800x600", "40x40", "300x300"};

function table.contains(table, element)

    for _, value in pairs(table) do

        if value == element then

            return true

        end

    end

    return false

end

if table.contains(image_sizes, area1) then
    local command = "/usr/local/GraphicsMagick/bin/gm convert " .. originalFile1  .. " -thumbnail " .. area1 .. " -background white -gravity center -extent " .. area1 .. " " .. ngx.var.file;
    os.execute(command);
    ngx.exec(ngx.var.uri);
else
    --返回原图
    ngx.exec(originalUri);
end;

